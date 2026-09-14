{
  buildOctavePackage,
  lib,
  fetchurl,
  gnuplot,
  makeFontsConf,
  writableTmpDirAsHomeHook,
}:

buildOctavePackage rec {
  pname = "image";
  version = "2.20.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-tLaGXn9l7lucJUppEovxDpOzi8J/W8W5c/7zACF/xyU=";
  };

  nativeOctavePkgTestInputs = [
    gnuplot
    writableTmpDirAsHomeHook
  ];

  octavePkgTestEnv.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  __structuredAttrs = true;

  meta = {
    homepage = "https://gnu-octave.github.io/packages/image/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Functions for processing images";
    longDescription = ''
      The Octave-forge Image package provides functions for processing
      images. The package also provides functions for feature extraction,
      image statistics, spatial and geometric transformations, morphological
      operations, linear filtering, and much more.
    '';
  };
}
