{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  io,
  datatypes,
  mesa,
  gnuplot,
  makeFontsConf,
  writableTmpDirAsHomeHook,
}:

buildOctavePackage rec {
  pname = "statistics";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "statistics";
    tag = "release-${version}";
    hash = "sha256-5wUQLIMr1X07Yi4AANBFjd0izDzGNsI5ccY7IherB3I=";
  };

  requiredOctavePackages = [
    io
    datatypes
  ];

  nativeOctavePkgTestInputs = [
    mesa
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
