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
, lld
, llvm
, makeWrapper
, perl
, python
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

stdenv.mkDerivation rec {
  name = "hip";
  version = "4.3.1";
  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "HIP";
    rev = "rocm-${version}";
    sha256 = "sha256-dUdP32H0u6kVItS+VUE549vvxkV1mSN84HvyfeK2hEE=";
  };

  # FIXME: https://github.com/ROCm-Developer-Tools/HIP/issues/2317
  postPatch = ''
    cp ${rocm-opencl-runtime.src}/amdocl/cl_vk_amd.hpp amdocl/
  '';

  nativeBuildInputs = [ cmake python makeWrapper ];
  propagatedBuildInputs = [
    clang
    compiler-rt
    lld
    llvm
    rocclr
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

  # The patch version is the last two digits of year + week number +
  # day in the week: date -d "2021-07-25" +%y%U%w
  workweek = "21300";

  cmakeFlags = [
    "-DHSA_PATH=${rocm-runtime}"
    "-DHIP_COMPILER=clang"
    "-DHIP_PLATFORM=amd"
    "-DHIP_VERSION_GITDATE=${workweek}"
    "-DCMAKE_C_COMPILER=${clang}/bin/clang"
    "-DCMAKE_CXX_COMPILER=${clang}/bin/clang++"
    "-DLLVM_ENABLE_RTTI=ON"
    "-DLIBROCclr_STATIC_DIR=${rocclr}/lib/cmake"
    "-DROCclr_DIR=${rocclr}"
    "-DHIP_CLANG_ROOT=${clang-unwrapped}"
  ];

  patches = [
    (fetchpatch {
      name = "no-git-during-build";
      url = "https://github.com/acowley/HIP/commit/310b7e972cfb23216250c0240ba6134741679aee.patch";
      sha256 = "08ky7v1yvajabn9m5x3afzrnz38gnrgc7vgqlbyr7s801c383ha1";
    })
    (fetchpatch {
      name = "use-PATH-when-compiling-pch";
      url = "https://github.com/acowley/HIP/commit/bfb4dd1eafa9714a2c05a98229cc35ffa3429b37.patch";
      sha256 = "1wp0m32df7pf4rhx3k5n750fd7kz10zr60z0wllb0mw6h00w6xpz";
    })
  ];

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

    for f in $(find . -regex '.*\.cpp\|.*\.h\(pp\)?'); do
      if grep -q __hcc_workweek__ "$f" ; then
        substituteInPlace "$f" --replace '__hcc_workweek__' '${workweek}'
      fi
    done

    sed 's,#!/usr/bin/python,#!${python}/bin/python,' -i hip_prof_gen.py

    sed -e 's,$ROCM_AGENT_ENUM = "''${ROCM_PATH}/bin/rocm_agent_enumerator";,$ROCM_AGENT_ENUM = "${rocminfo}/bin/rocm_agent_enumerator";,' \
        -e "s,^\($HIP_LIB_PATH=\).*$,\1\"$out/lib\";," \
        -e 's,^\($HIP_CLANG_PATH=\).*$,\1"${clang}/bin";,' \
        -e 's,^\($DEVICE_LIB_PATH=\).*$,\1"${rocm-device-libs}/amdgcn/bitcode";,' \
        -e 's,^\($HIP_COMPILER=\).*$,\1"clang";,' \
        -e 's,^\($HIP_RUNTIME=\).*$,\1"ROCclr";,' \
        -e 's,^\([[:space:]]*$HSA_PATH=\).*$,\1"${rocm-runtime}";,'g \
        -e 's,\([[:space:]]*$HOST_OSNAME=\).*,\1"nixos";,' \
        -e 's,\([[:space:]]*$HOST_OSVER=\).*,\1"${lib.versions.majorMinor lib.version}";,' \
        -e 's,^\([[:space:]]*\)$HIP_CLANG_INCLUDE_PATH = abs_path("$HIP_CLANG_PATH/../lib/clang/$HIP_CLANG_VERSION/include");,\1$HIP_CLANG_INCLUDE_PATH = "${clang-unwrapped}/lib/clang/$HIP_CLANG_VERSION/include";,' \
        -e 's,^\([[:space:]]*$HIPCXXFLAGS .= " -isystem $HIP_CLANG_INCLUDE_PATH\)";,\1 -isystem ${rocm-runtime}/include";,' \
        -e 's,\($HIPCXXFLAGS .= " -isystem \\"$HIP_INCLUDE_PATH\\"\)" ;,\1 --rocm-path=${rocclr}";,' \
        -e "s,\$HIP_PATH/\(bin\|lib\),$out/\1,g" \
        -e "s,^\$HIP_LIB_PATH=\$ENV{'HIP_LIB_PATH'};,\$HIP_LIB_PATH=\"$out/lib\";," \
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

    sed -e 's|_IMPORT_PREFIX}/../include|_IMPORT_PREFIX}/include|g' \
        -e 's|''${HIP_CLANG_ROOT}/lib/clang/\*/include|${clang-unwrapped}/lib/clang/*/include|' \
        -i hip-config.cmake.in
  '';

  preInstall = ''
    mkdir -p $out/lib/cmake
  '';

  # The upstream ROCclr setup wants everything built into the same
  # ROCclr output directory. We copy things into the HIP output
  # directory, since it is downstream of ROCclr in terms of dependency
  # direction. Thus we have device-libs and rocclr pieces in the HIP
  # output directory.
  postInstall = ''
    mkdir -p $out/share
    mv $out/lib/cmake $out/share/
    mv $out/cmake/* $out/share/cmake/hip
    mkdir -p $out/lib
    ln -s ${rocm-device-libs}/lib $out/lib/bitcode
    mkdir -p $out/include
    ln -s ${clang-unwrapped}/lib/clang/11.0.0/include $out/include/clang
    ln -s ${rocclr}/lib/*.* $out/lib
    ln -s ${rocclr}/include/* $out/include
    wrapProgram $out/bin/hipcc --set HIP_PATH $out --set HSA_PATH ${rocm-runtime} --set HIP_CLANG_PATH ${clang}/bin --prefix PATH : ${lld}/bin --set NIX_CC_WRAPPER_TARGET_HOST_${stdenv.cc.suffixSalt} 1 --prefix NIX_LDFLAGS ' ' -L${compiler-rt}/lib --prefix NIX_LDFLAGS_FOR_TARGET ' ' -L${compiler-rt}/lib
    wrapProgram $out/bin/hipconfig --set HIP_PATH $out --set HSA_PATH ${rocm-runtime} --set HIP_CLANG_PATH ${clang}/bin
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl -sL "https://api.github.com/repos/ROCm-Developer-Tools/HIP/tags" | jq '.[].name | split("-") | .[1] | select( . != null )' --raw-output | sort -n | tail -1)"
    update-source-version hip "$version"
  '';

  meta = with lib; {
    description = "C++ Heterogeneous-Compute Interface for Portability";
    homepage = "https://github.com/ROCm-Developer-Tools/HIP";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.linux;
  };
}
