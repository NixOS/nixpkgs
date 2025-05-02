{ lib
, aiomisc
, buildPythonPackage
, fetchPypi
, poetry-core
, pytest
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "aiomisc-pytest";
  version = "1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "aiomisc_pytest";
    inherit version;
    hash = "sha256-Zja0cNFrn6mUFlZOtzAtBJ/Gn27akD59qX6p88ytD6w=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "pytest"
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    aiomisc
  ];

  pythonImportsCheck = [
    "aiomisc_pytest"
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Pytest integration for aiomisc";
    homepage = "https://github.com/aiokitchen/aiomisc-pytest";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
