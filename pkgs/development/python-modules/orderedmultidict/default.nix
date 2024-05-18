{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "orderedmultidict";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "gruns";
    repo = "orderedmultidict";
    rev = "refs/tags/v${version}";
    hash = "sha256-ESuv/8p3DOlREDkem3B3uPh6pPMVetsiWb2ZoH7U+k4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "orderedmultidict"
  ];

  meta = with lib; {
    description = "Module for ordered multivalue dictionaries";
    homepage = "https://github.com/gruns/orderedmultidict";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ vanzef ];
  };
}
