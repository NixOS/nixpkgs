{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "coolname";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alexanderlukanin13";
    repo = "coolname";
    tag = version;
    hash = "sha256-3rQAcaZOVrYvjoeu9ttodLZVuVgg85KduNOm2KgitnE=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "coolname"
  ];

  # Tests require coolname.data to be packaged
  doCheck = false;

  meta = {
    description = "Random Name and Slug Generator";
    homepage = "https://github.com/alexanderlukanin13/coolname";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
