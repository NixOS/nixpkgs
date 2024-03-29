{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatch-requirements-txt
, domdf-python-tools
, idna
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "apeye-core";
  version = "1.1.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "domdfcoding";
    repo = "apeye-core";
    rev = "v${version}";
    hash = "sha256-qWuJAch0x7Mmf3f8tXdHnxVUXSHVA9PCZsSAkIpKIRQ=";
  };

  build-system = [
    hatch-requirements-txt
  ];

  dependencies = [
    domdf-python-tools
    idna
  ];

  pythonImportsCheck = [ "apeye_core" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # requires coincidence which hasn't been packaged yet
  doCheck = false;

  meta = {
    description = "Core (offline) functionality for the apeye library";
    homepage = "https://github.com/domdfcoding/apeye-core";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
