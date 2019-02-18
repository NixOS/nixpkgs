{ llvmPackages, lib, fetchFromGitHub, cmake
, libpng, libjpeg, mesa_noglu, eigen, openblas
}:

let
  version = "2018_02_15";

in llvmPackages.stdenv.mkDerivation {

  name = "halide-${builtins.replaceStrings ["_"] ["."] version}";

  src = fetchFromGitHub {
    owner = "halide";
    repo = "Halide";
    rev = "release_${version}";
    sha256 = "14lmpbxydx7ii0pxds6rgq5vw4i6yfjsq0bai1l5wwpv1rnwmbxd";
  };

  patches = [ ./nix.patch ];

  # clang fails to compile intermediate code because
  # of unused "--gcc-toolchain" option
  postPatch = ''
    sed -i "s/-Werror//" src/CMakeLists.txt
  '';

  cmakeFlags = [ "-DWARNINGS_AS_ERRORS=OFF" ];

  # To handle the lack of 'local' RPATH; required, as they call one of
  # their built binaries requiring their libs, in the build process.
  preBuild = ''
    export LD_LIBRARY_PATH="$(pwd)/lib:$LD_LIBRARY_PATH"
  '';

  enableParallelBuilding = true;

  # Note: only openblas and not atlas part of this Nix expression
  # see pkgs/development/libraries/science/math/liblapack/3.5.0.nix
  # to get a hint howto setup atlas instead of openblas
  buildInputs = [ llvmPackages.llvm libpng libjpeg mesa_noglu eigen openblas ];

  nativeBuildInputs = [ cmake ];

  # No install target for cmake available.
  # Calling install target in Makefile causes complete rebuild
  # and the library rpath is broken, because libncursesw.so.6 is missing.
  # Another way is using "make halide_archive", but the tarball is not easy
  # to disassemble.
  installPhase = ''
    find
    mkdir -p "$out/lib" "$out/bin"
    cp bin/HalideTrace* "$out/bin"
    cp lib/libHalide.so "$out/lib"
    cp -r include "$out"
  '';

  meta = with lib; {
    description = "C++ based language for image processing and computational photography";
    homepage = "https://halide-lang.org";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.ck3d ];
  };
}
