{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, jsonschema
, pytest
, pyyaml
}:

buildPythonPackage rec {
  pname = "pytest-workflow";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LUMC";
    repo = "pytest-workflow";
    rev = "v${version}";
    hash = "sha256-ztR4TW41qVAnCLXPUsWaiMuD1ESL0Kvd5KAsOf8tcE0=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    jsonschema
    pytest
    pyyaml
  ];

  pythonImportsCheck = [ "pytest_workflow" ];

  meta = with lib; {
    description = "Configure workflow/pipeline tests using yaml files";
    homepage = "https://github.com/LUMC/pytest-workflow";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ edmundmiller ];
  };
}
