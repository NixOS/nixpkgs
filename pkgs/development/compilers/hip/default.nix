{ stdenv
, binutils-unwrapped
, clang
, cmake
, fetchFromGitHub
, fetchpatch
, file
, lib
, libglvnd
, libX11
, libxml2
, llvm
, makeWrapper
, numactl
, perl
, python3
, rocclr
, rocm-comgr
, rocm-device-libs
, rocm-opencl-runtime
, rocm-runtime
, rocm-thunk
, rocminfo
, writeScript
, writeText
}:

let
  hip = stdenv.mkDerivation rec {
    pname = "hip";
    version = "5.2.1";

    src = fetchFromGitHub {
      owner = "ROCm-Developer-Tools";
      repo = "HIP";
      rev = "rocm-${version}";
      hash = "sha256-aXI55bdhAuPUEdQZukKAdtLWA+8UIxjPJ4LTamR/ENk=";
    };

    # - fix bash paths
    # - fix path to rocm_agent_enumerator
    # - fix hcc path
    # - fix hcc version parsing
    # - add linker flags for libhsa-runtime64 and hc_am since libhip_hcc
    #   refers to them.
    prePatch = ''
      for f in $(find bin -type f); do
        sed -e 's,#!/usr/bin/perl,#!${perl}/bin/perl,' \
            -e 's,#!/bin/bash,#!${stdenv.shell},' \
            -i "$f"
      done

      substituteInPlace bin/hip_embed_pch.sh \
        --replace '$LLVM_DIR/bin/' ""

      sed 's,#!/usr/bin/python,#!${python3.interpreter},' -i hip_prof_gen.py

      sed -e 's,$ROCM_AGENT_ENUM = "''${ROCM_PATH}/bin/rocm_agent_enumerator";,$ROCM_AGENT_ENUM = "${rocminfo}/bin/rocm_agent_enumerator";,' \
          -e 's,^\($DEVICE_LIB_PATH=\).*$,\1"${rocm-device-libs}/amdgcn/bitcode";,' \
          -e 's,^\($HIP_COMPILER=\).*$,\1"clang";,' \
          -e 's,^\($HIP_RUNTIME=\).*$,\1"ROCclr";,' \
          -e 's,^\([[:space:]]*$HSA_PATH=\).*$,\1"${rocm-runtime}";,'g \
          -e 's,^\([[:space:]]*\)$HIP_CLANG_INCLUDE_PATH = abs_path("$HIP_CLANG_PATH/../lib/clang/$HIP_CLANG_VERSION/include");,\1$HIP_CLANG_INCLUDE_PATH = "${llvm}/lib/clang/$HIP_CLANG_VERSION/include";,' \
          -e 's,^\([[:space:]]*$HIPCXXFLAGS .= " -isystem \\"$HIP_CLANG_INCLUDE_PATH/..\\"\)";,\1 -isystem ${rocm-runtime}/include";,' \
          -e 's,$HIP_CLANG_PATH/../lib/clang/$HIP_CLANG_VERSION,$HIP_CLANG_PATH/../resource-root,g' \
          -e 's,`file,`${file}/bin/file,g' \
          -e 's,`readelf,`${binutils-unwrapped}/bin/readelf,' \
          -e 's, ar , ${binutils-unwrapped}/bin/ar ,g' \
          -i bin/hipcc.pl

      sed -e 's,^\($HSA_PATH=\).*$,\1"${rocm-runtime}";,' \
          -e 's,^\($HIP_CLANG_PATH=\).*$,\1"${clang}/bin";,' \
          -e 's,^\($HIP_PLATFORM=\).*$,\1"amd";,' \
          -e 's,$HIP_CLANG_PATH/llc,${llvm}/bin/llc,' \
          -e 's, abs_path, Cwd::abs_path,' \
          -i bin/hipconfig.pl

      sed -e 's, abs_path, Cwd::abs_path,' -i bin/hipvars.pm
    '';

    buildPhase = "";

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r * $out/

      runHook postInstall
    '';

    meta = with lib; {
      description = "C++ Heterogeneous-Compute Interface for Portability";
      homepage = "https://github.com/ROCm-Developer-Tools/HIP";
      license = licenses.mit;
      maintainers = with maintainers; [ lovesegfault ];
      platforms = platforms.linux;
    };
  };
in
stdenv.mkDerivation rec {
  pname = "hip";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "hipamd";
    rev = "rocm-${version}";
    hash = "sha256-YsvM+HjoBiukXAMCdE/dpQNMnpP6XRXDuxV1487rok0=";
  };

  nativeBuildInputs = [ cmake python3 makeWrapper perl ];
  buildInputs = [ libxml2 numactl libglvnd libX11 ];
  propagatedBuildInputs = [
    clang
    llvm
    rocm-comgr
    rocm-device-libs
    rocm-runtime
    rocm-thunk
    rocminfo
  ];

  preConfigure = ''
    export HIP_CLANG_PATH=${clang}/bin
    export DEVICE_LIB_PATH=${rocm-device-libs}/lib
  '';

  cmakeFlags = [
    "-DHIP_PLATFORM=amd"
    "-DAMD_OPENCL_PATH=${rocm-opencl-runtime.src}"
    "-DHIP_COMMON_DIR=${hip}"
    "-DROCCLR_PATH=${rocclr}"
    "-DHIP_VERSION_BUILD_ID=0"
  ];

  postInstall = ''
    patchShebangs $out/bin
    wrapProgram $out/bin/hipcc --set HIP_PATH $out --set HSA_PATH ${rocm-runtime} --set HIP_CLANG_PATH ${clang}/bin --prefix PATH : ${llvm}/bin --set ROCM_PATH $out
    wrapProgram $out/bin/hipconfig --set HIP_PATH $out --set HSA_PATH ${rocm-runtime} --set HIP_CLANG_PATH ${clang}/bin
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts nix-prefetch-github
    version="$(curl -sL "https://api.github.com/repos/ROCm-Developer-Tools/HIP/tags" | jq '.[].name | split("-") | .[1] | select( . != null )' --raw-output | sort -n | tail -1)"
    current_version="$(grep "version =" pkgs/development/compilers/hip/default.nix | head -n1 | cut -d'"' -f2)"
    if [[ "$version" != "$current_version" ]]; then
      tarball_meta="$(nix-prefetch-github ROCm-Developer-Tools HIP --rev "rocm-$version")"
      tarball_hash="$(nix to-base64 sha256-$(jq -r '.sha256' <<< "$tarball_meta"))"
      sed -i -z "pkgs/development/compilers/hip/default.nix" \
        -e 's,version = "[^'"'"'"]*",version = "'"$version"'",1' \
        -e 's,hash = "[^'"'"'"]*",hash = "sha256-'"$tarball_hash"'",1'
    else
      echo hip already up-to-date
    fi

    version="$(curl -sL "https://api.github.com/repos/ROCm-Developer-Tools/hipamd/tags" | jq '.[].name | split("-") | .[1] | select( . != null )' --raw-output | sort -n | tail -1)"
    current_version="$(grep "version =" pkgs/development/compilers/hip/default.nix | tail -n1 | cut -d'"' -f2)"
    if [[ "$version" != "$current_version" ]]; then
      tarball_meta="$(nix-prefetch-github ROCm-Developer-Tools hipamd --rev "rocm-$version")"
      tarball_hash="$(nix to-base64 sha256-$(jq -r '.sha256' <<< "$tarball_meta"))"
      sed -i -z "pkgs/development/compilers/hip/default.nix" \
        -e 's,version = "[^'"'"'"]*",version = "'"$version"'",2' \
        -e 's,hash = "[^'"'"'"]*",hash = "sha256-'"$tarball_hash"'",2'
    else
      echo hipamd already up-to-date
    fi
  '';

  meta = with lib; {
    description = "C++ Heterogeneous-Compute Interface for Portability";
    homepage = "https://github.com/ROCm-Developer-Tools/hipamd";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.linux;
  };
}
