{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gfortran,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcfun";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "dftlibs";
    repo = "xcfun";
    rev = "v${finalAttrs.version}";
    sha256 = "1bj70cnhbh6ziy02x988wwl7cbwaq17ld7qwhswqkgnnx8rpgxid";
  };

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  propagatedBuildInputs = [ (python3.withPackages (p: with p; [ pybind11 ])) ];

  cmakeFlags = [ "-DXCFUN_MAX_ORDER=3" ];

  meta = {
    description = "Library of exchange-correlation functionals with arbitrary-order derivatives";
    homepage = "https://github.com/dftlibs/xcfun";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
