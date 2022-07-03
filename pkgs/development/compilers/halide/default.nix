{ llvmPackages
, lib
, fetchFromGitHub
, cmake
, libpng
, libjpeg
, mesa
, eigen
, openblas
, blas
, lapack
}:

assert blas.implementation == "openblas" && lapack.implementation == "openblas";

llvmPackages.stdenv.mkDerivation rec {
  pname = "halide";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "halide";
    repo = "Halide";
    rev = "v${version}";
    sha256 = "0il71rppjp76m7zd420siidvhs76sqiq26h60ywk812sj9mmgxj6";
  };

  # clang fails to compile intermediate code because
  # of unused "--gcc-toolchain" option
  postPatch = ''
    sed -i "s/-Werror//" src/CMakeLists.txt
  '';

  cmakeFlags = [ "-DWARNINGS_AS_ERRORS=OFF" "-DWITH_PYTHON_BINDINGS=OFF" ];

  # Note: only openblas and not atlas part of this Nix expression
  # see pkgs/development/libraries/science/math/liblapack/3.5.0.nix
  # to get a hint howto setup atlas instead of openblas
  buildInputs = [
    llvmPackages.llvm
    llvmPackages.lld
    llvmPackages.openmp
    llvmPackages.libclang
    libpng
    libjpeg
    mesa
    eigen
    openblas
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "C++ based language for image processing and computational photography";
    homepage = "https://halide-lang.org";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ck3d atila ];
  };
}
