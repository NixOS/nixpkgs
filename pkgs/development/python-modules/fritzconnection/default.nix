{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "fritzconnection";
  version = "1.7.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kbr";
    repo = pname;
    rev = version;
    sha256 = "sha256-yrkFtvGXkeHD5hp0Fzz3M1hsuSIt6bQriyUy4NagD0U=";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fritzconnection" ];

  meta = with lib; {
    description = "Python module to communicate with the AVM Fritz!Box";
    homepage = "https://github.com/kbr/fritzconnection";
    changelog = "https://fritzconnection.readthedocs.io/en/${version}/sources/changes.html";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda valodim ];
  };
}
