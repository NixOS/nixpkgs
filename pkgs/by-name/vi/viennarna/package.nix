{
  lib,
  stdenv,
  fetchurl,
  dlib,
  gsl,
  mpfr,
  perl,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "viennarna";
  version = "2.7.0";

  src = fetchurl {
    url = "https://www.tbi.univie.ac.at/RNA/download/sourcecode/2_7_x/ViennaRNA-${version}.tar.gz";
    hash = "sha256-mpn9aO04CJTe+01eaooocWKScAKM338W8KBdpujHFHM=";
  };

  # use nixpkgs dlib sources instead of bundled ones
  # using dlib-19.24.8 fixes the build with modern compilers (such as clang-19)
  postPatch = ''
    rm -rf ./src/dlib-19.24
    cp -a ${dlib.src} ./src/dlib-19.24
    find ./src/dlib-19.24 -type d -exec chmod +w {} \;
  '';

  buildInputs = [
    gsl
    mpfr
    perl
    python3
  ];

  configureFlags = [
    "--with-cluster"
    "--with-kinwalker"
  ];

  meta = {
    description = "Prediction and comparison of RNA secondary structures";
    homepage = "https://www.tbi.univie.ac.at/RNA/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ prusnak ];
    platforms = lib.platforms.unix;
  };
}
