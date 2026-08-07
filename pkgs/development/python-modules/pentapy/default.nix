{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,
  setuptools-scm,

  # dependencies
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pentapy";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GeoStat-Framework";
    repo = "pentapy";
    tag = "v${version}";
    hash = "sha256-lw512rZCrwumDunoWFfd0HxCv0HAn/bAmIz8l8VeBP8=";
  };

  build-system = [
    cython
    numpy
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "A Python toolbox for pentadiagonal linear systems";
    homepage = "https://github.com/GeoStat-Framework/pentapy";
    changelog = "https://github.com/GeoStat-Framework/pentapy/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
  };
}
