{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "exceptiongroup";
  version = "1.0.4";
  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vRSWe3nNm9tU2XMjIW+P31M+J435N6oqkAiefW4G5ew=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # Tests are only in the source available but tagged releases
  # are incomplete as files are generated during the release process
  doCheck = false;

  pythonImportsCheck = [
    "exceptiongroup"
  ];

  meta = with lib; {
    description = "Backport of PEP 654 (exception groups)";
    homepage = "https://github.com/agronholm/exceptiongroup";
    changelog = "https://github.com/agronholm/exceptiongroup/blob/${version}/CHANGES.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
