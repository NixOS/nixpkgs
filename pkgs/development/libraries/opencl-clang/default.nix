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

  addPatches = component: pkg: pkg.overrideAttrs (oldAttrs: {
    postPatch = oldAttrs.postPatch or "" + ''
      for p in ${passthru.patchesOut}/${component}/*; do
        patch -p1 -i "$p"
      done
    '';
  });

  passthru = rec {
    spirv-llvm-translator = llvmPkgs.spirv-llvm-translator.override { llvm = llvmPackages_11.llvm; };
    llvm = addPatches "llvm" llvmPkgs.llvm;
    libclang = addPatches "clang" llvmPkgs.libclang;

    clang-unwrapped = libclang.out;
    clang = llvmPkgs.clang.override {
      cc = clang-unwrapped;
    };

    patchesOut = stdenv.mkDerivation {
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
    inherit (llvmPackages_11) llvm;
    inherit (if buildWithPatches then passthru else llvmPkgs) libclang spirv-llvm-translator;
  in
    stdenv.mkDerivation {
      pname = "opencl-clang";
      version = "unstable-2022-03-16";


      src = fetchFromGitHub {
        owner = "intel";
        repo = "opencl-clang";
        rev = "bbdd1587f577397a105c900be114b56755d1f7dc";
        sha256 = "sha256-qEZoQ6h4XAvSnJ7/gLXBb1qrzeYa6Jp6nij9VFo8MwQ=";
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
        "-DPREFERRED_LLVM_VERSION=${lib.getVersion llvm}"
        "-DOPENCL_HEADERS_DIR=${libclang.lib}/lib/clang/${lib.getVersion libclang}/include/"

        "-DLLVMSPIRV_INCLUDED_IN_LLVM=OFF"
        "-DSPIRV_TRANSLATOR_DIR=${spirv-llvm-translator}"
      ];

      inherit passthru;

      meta = with lib; {
        homepage    = "https://github.com/intel/opencl-clang/";
        description = "A clang wrapper library with an OpenCL-oriented API and the ability to compile OpenCL C kernels to SPIR-V modules";
        license     = licenses.ncsa;
        platforms   = platforms.all;
        maintainers = with maintainers; [ SuperSandro2000 ];
      };
    };
in
  library
