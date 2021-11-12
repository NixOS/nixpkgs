{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, git

, llvmPackages_11
, spirv-llvm-translator

, buildWithPatches ? true
}:

let
  llvmPkgs = llvmPackages_11 // {
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
    spirv-llvm-translator = llvmPkgs.spirv-llvm-translator;
    llvm = addPatches "llvm" llvmPkgs.llvm;
    libclang = addPatches "clang" llvmPkgs.libclang;

    clang-unwrapped = libclang.out;

    clang = llvmPkgs.clang.override {
      cc = clang-unwrapped;
    };

    patchesOut = stdenv.mkDerivation rec {
      pname = "opencl-clang-patches";
      inherit (library) version src patches;
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

  library = let
    inherit (llvmPkgs) llvm;
    inherit (if buildWithPatches then passthru else llvmPkgs) libclang spirv-llvm-translator;
  in
    stdenv.mkDerivation rec {
      pname = "opencl-clang";
      version = "unstable-2021-06-22";

      inherit passthru;

      src = fetchFromGitHub {
        owner = "intel";
        repo = "opencl-clang";
        rev = "fd68f64b33e67d58f6c36b9e25c31c1178a1962a";
        sha256 = "sha256-q1YPBb/LY67iEuQx1fMUQD/I7OsNfobW3yNfJxLXx3E=";
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
