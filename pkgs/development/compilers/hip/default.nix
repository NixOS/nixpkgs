{ stdenv
, binutils-unwrapped
, clang
, clang-unwrapped
, cmake
, compiler-rt
, fetchFromGitHub
, fetchpatch
, file
, lib
, libglvnd
, libX11
, libxml2
, lld
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
    version = "4.5.2";

    src = fetchFromGitHub {
      owner = "ROCm-Developer-Tools";
      repo = "HIP";
      rev = "rocm-${version}";
      sha256 = "sha256-AuA5ubRPywXaBBrjdHg5AT8rrVKULKog6Lh8jPaUcXY=";
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
          -e 's,^\([[:space:]]*\)$HIP_CLANG_INCLUDE_PATH = abs_path("$HIP_CLANG_PATH/../lib/clang/$HIP_CLANG_VERSION/include");,\1$HIP_CLANG_INCLUDE_PATH = "${clang-unwrapped}/lib/clang/$HIP_CLANG_VERSION/include";,' \
          -e 's,^\([[:space:]]*$HIPCXXFLAGS .= " -isystem \\"$HIP_CLANG_INCLUDE_PATH/..\\"\)";,\1 -isystem ${rocm-runtime}/include";,' \
          -e 's,`file,`${file}/bin/file,g' \
          -e 's,`readelf,`${binutils-unwrapped}/bin/readelf,' \
          -e 's, ar , ${binutils-unwrapped}/bin/ar ,g' \
          -i bin/hipcc

      sed -e 's,^\($HSA_PATH=\).*$,\1"${rocm-runtime}";,' \
          -e 's,^\($HIP_CLANG_PATH=\).*$,\1"${clang}/bin";,' \
          -e 's,^\($HIP_PLATFORM=\).*$,\1"amd";,' \
          -e 's,$HIP_CLANG_PATH/llc,${llvm}/bin/llc,' \
          -e 's, abs_path, Cwd::abs_path,' \
          -i bin/hipconfig

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
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "hipamd";
    rev = "rocm-${version}";
    sha256 = "WvOuQu/EN81Kwcoc3ZtGlhb996edQJ3OWFsmPuqeNXE=";
  };

  nativeBuildInputs = [ cmake python3 makeWrapper perl ];
  buildInputs = [ libxml2 numactl libglvnd libX11 ];
  propagatedBuildInputs = [
    clang
    compiler-rt
    lld
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
  ];

  postInstall = ''
    wrapProgram $out/bin/hipcc --set HIP_PATH $out --set HSA_PATH ${rocm-runtime} --set HIP_CLANG_PATH ${clang}/bin --prefix PATH : ${lld}/bin --set NIX_CC_WRAPPER_TARGET_HOST_${stdenv.cc.suffixSalt} 1 --prefix NIX_LDFLAGS ' ' -L${compiler-rt}/lib --prefix NIX_LDFLAGS_FOR_TARGET ' ' -L${compiler-rt}/lib --add-flags "-nogpuinc"
    wrapProgram $out/bin/hipconfig --set HIP_PATH $out --set HSA_PATH ${rocm-runtime} --set HIP_CLANG_PATH ${clang}/bin
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl -sL "https://api.github.com/repos/ROCm-Developer-Tools/hipamd/tags" | jq '.[].name | split("-") | .[1] | select( . != null )' --raw-output | sort -n | tail -1)"
    update-source-version hip "$version"
  '';

  meta = with lib; {
    description = "C++ Heterogeneous-Compute Interface for Portability";
    homepage = "https://github.com/ROCm-Developer-Tools/hipamd";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.linux;
  };
}
