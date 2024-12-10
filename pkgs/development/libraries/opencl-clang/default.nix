{
  lib,
  stdenv,
  applyPatches,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  git,
  llvmPackages_14,
  spirv-llvm-translator,
  buildWithPatches ? true,
}:

let
  addPatches =
    component: pkg:
    pkg.overrideAttrs (oldAttrs: {
      postPatch =
        oldAttrs.postPatch or ""
        + ''
          for p in ${passthru.patchesOut}/${component}/*; do
            patch -p1 -i "$p"
          done
        '';
    });

  llvmPkgs = llvmPackages_14;
  inherit (llvmPkgs) llvm;
  spirv-llvm-translator' = spirv-llvm-translator.override { inherit llvm; };
  libclang = if buildWithPatches then passthru.libclang else llvmPkgs.libclang;

  passthru = rec {
    spirv-llvm-translator = spirv-llvm-translator';
    llvm = addPatches "llvm" llvmPkgs.llvm;
    libclang = addPatches "clang" llvmPkgs.libclang;

    clang-unwrapped = libclang.out;
    clang = llvmPkgs.clang.override {
      cc = clang-unwrapped;
    };

    patchesOut = stdenv.mkDerivation {
      pname = "opencl-clang-patches";
      inherit version src;
      # Clang patches assume the root is the llvm root dir
      # but clang root in nixpkgs is the clang sub-directory
      postPatch = ''
        for filename in patches/clang/*.patch; do
          substituteInPlace "$filename" \
            --replace "a/clang/" "a/" \
            --replace "b/clang/" "b/"
        done
      '';

      installPhase = ''
        [ -d patches ] && cp -r patches/ $out || mkdir $out
        mkdir -p $out/clang $out/llvm
      '';
    };
  };

  version = "unstable-2023-06-12";
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "intel";
      repo = "opencl-clang";
      # https://github.com/intel/opencl-clang/compare/ocl-open-140
      rev = "cf95b338d14685e4f3402ab1828bef31d48f1fd6";
      hash = "sha256-To1RlQX9IJ+1zAwEXaW7ua3VNfjK9mu7pgsRPsfa8g8=";
    };

    patches = [
      # Build script tries to find Clang OpenCL headers under ${llvm}
      # Work around it by specifying that directory manually.
      ./opencl-headers-dir.patch

      # fix CMake throwing errors
      (fetchpatch {
        url = "https://github.com/intel/opencl-clang/commit/321e3b99c1a8d54c8475f5ae998452069cc5eb71.patch";
        hash = "sha256-cATbH+AMVtcabhl3EkzAH7w3wGreUV53hQYHVUUEP4g=";
      })
    ];

    postPatch =
      ''
        # fix not be able to find clang from PATH
        substituteInPlace cl_headers/CMakeLists.txt \
          --replace " NO_DEFAULT_PATH" ""
      ''
      + lib.optionalString stdenv.isDarwin ''
        # Uses linker flags that are not supported on Darwin.
        sed -i -e '/SET_LINUX_EXPORTS_FILE/d' CMakeLists.txt
        substituteInPlace CMakeLists.txt \
          --replace '-Wl,--no-undefined' ""
      '';
  };
in

stdenv.mkDerivation {
  pname = "opencl-clang";
  inherit version src;

  nativeBuildInputs = [
    cmake
    git
    llvm.dev
  ];

  buildInputs = [
    libclang
    llvm
    spirv-llvm-translator'
  ];

  cmakeFlags = [
    "-DPREFERRED_LLVM_VERSION=${lib.getVersion llvm}"
    "-DOPENCL_HEADERS_DIR=${libclang.lib}/lib/clang/${lib.getVersion libclang}/include/"

    "-DLLVMSPIRV_INCLUDED_IN_LLVM=OFF"
    "-DSPIRV_TRANSLATOR_DIR=${spirv-llvm-translator'}"
  ];

  inherit passthru;

  meta = with lib; {
    homepage = "https://github.com/intel/opencl-clang/";
    description = "A clang wrapper library with an OpenCL-oriented API and the ability to compile OpenCL C kernels to SPIR-V modules";
    license = licenses.ncsa;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
    # error: invalid value 'CL3.0' in '-cl-std=CL3.0'
    broken = stdenv.isDarwin;
  };
}
