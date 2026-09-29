{
  lib,
  buildPythonPackage,
  fetchFromGitea,

  # build-system
  setuptools,

  # dependencies
  foss-flame,
  licomp,
  licomp-doubleopen,
  licomp-dwheeler,
  licomp-gnuguide,
  licomp-hermione,
  licomp-osadl,
  licomp-oslc-handbook,
  licomp-proprietary,
  licomp-reclicense,
  pyyaml,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "licomp-toolkit";
  version = "0.5.20";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "software-compliance-org";
    repo = "licomp-toolkit";
    tag = finalAttrs.version;
    hash = "sha256-E6ehhQj1EcpW+8Cf2b+dtYSCH7fQ/AgS8uWIN4ipeCQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    foss-flame
    licomp
    licomp-doubleopen
    licomp-dwheeler
    licomp-gnuguide
    licomp-hermione
    licomp-osadl
    licomp-oslc-handbook
    licomp-proprietary
    licomp-reclicense
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "licomp_toolkit"
  ];

  meta = {
    description = "Python module and program to check compatibility between two licenses with context";
    homepage = "https://codeberg.org/software-compliance-org/licomp-toolkit";
    mainProgram = "licomp-toolkit";
    license = with lib.licenses; [
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
    # TODO: remove when this is resolved:
    # https://github.com/hesa/licomp-oslc-handbook/issues/4
    badPlatforms = lib.platforms.darwin;
  };
})
