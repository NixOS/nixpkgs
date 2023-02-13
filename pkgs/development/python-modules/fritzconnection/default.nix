{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "fritzconnection";
  version = "1.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kbr";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-BHlOX5STnKaIOM5tiBZ9JHNQIYVZfIPDMuSw6DAJliA=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fritzconnection"
  ];

  meta = with lib; {
    description = "Python module to communicate with the AVM Fritz!Box";
    homepage = "https://github.com/kbr/fritzconnection";
    changelog = "https://fritzconnection.readthedocs.io/en/${version}/sources/changes.html";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda valodim ];
  };
}
