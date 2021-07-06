{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, git

, llvmPackages_8
, spirv-llvm-translator

, buildWithPatches ? true
}:

let
  llvmPkgs = llvmPackages_8 // {
    inherit spirv-llvm-translator;
  };

  inherit (lib) getVersion;

  addPatches = component: pkg:
    with builtins; with lib;
    let path = "${passthru.patchesOut}/${component}";
    in pkg.overrideAttrs (super: {
      postPatch = (if super ? postPatch then super.postPatch + "\n" else "") + ''
        for p in ${path}/*
        do
          patch -p1 -i "$p"
        done
      '';
    });

  passthru = rec {

    libclang = addPatches "clang" llvmPkgs.libclang;

    clang-unwrapped = libclang.out;

    clang = llvmPkgs.clang.override {
      cc = clang-unwrapped;
    };

    patchesOut = stdenv.mkDerivation rec {
      pname = "opencl-clang-patches";
      inherit (library) version src patches;
      installPhase = ''
        [ -d patches ] && cp -r patches/ $out || mkdir $out
        mkdir -p $out/clang $out/spirv
      '';
    };

    spirv-llvm-translator = addPatches "spirv" llvmPkgs.spirv-llvm-translator;

  };

  library = let
    inherit (llvmPkgs) llvm;
    inherit (if buildWithPatches then passthru else llvmPkgs) libclang spirv-llvm-translator;
  in
    stdenv.mkDerivation rec {
      pname = "opencl-clang";
      version = "unstable-2019-08-16";

      inherit passthru;

      src = fetchFromGitHub {
        owner = "intel";
        repo = "opencl-clang";
        rev = "94af090661d7c953c516c97a25ed053c744a0737";
        sha256 = "05cg89m62nqjqm705h7gpdz4jd4hiczg8944dcjsvaybrqv3hcm5";
      };

      patches = [
      # Build script tries to find Clang OpenCL headers under ${llvm}
      # Work around it by specifying that directory manually.
        ./opencl-headers-dir.patch
      ];

      # Uses linker flags that are not supported on Darwin.
      postPatch = lib.optionalString stdenv.isDarwin ''
        sed -i -e '/SET_LINUX_EXPORTS_FILE/d' CMakeLists.txt
        substituteInPlace CMakeLists.txt \
          --replace '-Wl,--no-undefined' ""
      '';

      nativeBuildInputs = [ cmake git llvm.dev ];

      buildInputs = [ libclang llvm spirv-llvm-translator ];

      cmakeFlags = [
        "-DPREFERRED_LLVM_VERSION=${getVersion llvm}"
        "-DOPENCL_HEADERS_DIR=${libclang.lib}/lib/clang/${getVersion libclang}/include/"

        "-DLLVMSPIRV_INCLUDED_IN_LLVM=OFF"
        "-DSPIRV_TRANSLATOR_DIR=${spirv-llvm-translator}"
      ];

      meta = with lib; {
        homepage    = "https://github.com/intel/opencl-clang/";
        description = "A clang wrapper library with an OpenCL-oriented API and the ability to compile OpenCL C kernels to SPIR-V modules";
        license     = licenses.ncsa;
        platforms   = platforms.all;
        maintainers = with maintainers; [ gloaming ];
      };
    };
in
  library
