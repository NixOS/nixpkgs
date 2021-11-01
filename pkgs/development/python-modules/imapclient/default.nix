{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "imapclient";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "mjs";
    repo = "imapclient";
    rev = version;
    sha256 = "sha256-q/8LFKHgrY3pQV7Coz+5pZAw696uABMTEkYoli6C2KA=";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestCheckHook mock ];

  meta = with lib; {
    homepage = "https://imapclient.readthedocs.io";
    description = "Easy-to-use, Pythonic and complete IMAP client library";
    license = licenses.bsd3;
    maintainers = with maintainers; [ almac dotlambda ];
  };
}
