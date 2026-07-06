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
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "statistics";
    tag = "release-${version}";
    hash = "sha256-1u/uXrbRNT14TbW89J8noCnwShD/B/Wz0cpurmsTzTU=";
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
