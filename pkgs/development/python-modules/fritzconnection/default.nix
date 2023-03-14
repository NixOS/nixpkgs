{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "fritzconnection";
  version = "1.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kbr";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-1giXmmyuy+qrY6xV3yZn4kcDd6w6l8uCL4ozcZE4N00=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  pythonImportsCheck = [
    "fritzconnection"
  ];

  meta = with lib; {
    description = "Python module to communicate with the AVM Fritz!Box";
    homepage = "https://github.com/kbr/fritzconnection";
    changelog = "https://fritzconnection.readthedocs.io/en/${version}/sources/version_history.html";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda valodim ];
  };
}
