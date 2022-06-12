{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "exceptiongroup";
  version = "1.0.0rc8";
  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aZDCTwa40zyAZc/kPl6KS/o4TgNYvgNq+cxgtjIb0Ro=";
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
