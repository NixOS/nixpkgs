{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, requests
, segno
}:

buildPythonPackage rec {
  pname = "fritzconnection";
  version = "1.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kbr";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FTg5LHjti6Srmz1LcPU0bepNzn2tpmdSBM3Y2BzZEms=";
  };

  propagatedBuildInputs = [
    requests
  ];

  passthru.optional-dependencies = {
    qr = [
      segno
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  pythonImportsCheck = [
    "fritzconnection"
  ];

  disabledTestPaths = [
    # Functional tests require network access
    "fritzconnection/tests/test_functional.py"
  ];

  meta = with lib; {
    description = "Python module to communicate with the AVM Fritz!Box";
    homepage = "https://github.com/kbr/fritzconnection";
    changelog = "https://fritzconnection.readthedocs.io/en/${version}/sources/version_history.html";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda valodim ];
  };
}
