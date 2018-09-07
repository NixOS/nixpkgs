{ llvmPackages, lib, fetchFromGitHub, cmake
, libpng, libjpeg, mesa_noglu, eigen3_3, openblas
}:

llvmPackages.stdenv.mkDerivation rec {

  pversion = "2018-08-31";
  name = "gradient-halide-${pversion}";

  src = fetchFromGitHub {
    owner = "jrk";
    repo = "gradient-halide";
    rev = "f630dd26eb141349d147f20ace39793d5bc717d2";
    sha256 = "0qhk1plc4697p1livf9xz2c5aqaq6v9sx1pr0ia6x7sjkmggc9rc";
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
  buildInputs = [ llvmPackages.llvm libpng libjpeg mesa_noglu eigen3_3 openblas ];

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
    description = "Differentiable version of the Halide C++ image and array processing framework";
    homepage = "https://halide-lang.org";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.bcdarwin ];
  };
}
