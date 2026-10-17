{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  io,
  datatypes,
  gnuplot,
  makeFontsConf,
  writableTmpDirAsHomeHook,
}:

buildOctavePackage rec {
  pname = "statistics";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "statistics";
    tag = "release-${version}";
    hash = "sha256-frpNqQ/LtIS9yMCZl08T3USK4kWMABJy+t5kqo+iGsQ=";
  };

  requiredOctavePackages = [
    io
    datatypes
  ];

  nativeOctavePkgTestInputs = [
    gnuplot
    writableTmpDirAsHomeHook
  ];

  octavePkgTestEnv.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  __structuredAttrs = true;

  meta = {
    homepage = "https://packages.octave.org/statistics";
    license = with lib.licenses; [
      gpl3Plus
      publicDomain
    ];
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Statistics package for GNU Octave";
  };
}
