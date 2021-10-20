{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, oauthlib
, python-dateutil
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "discogs-client";
  version = "2.3.12";


  src = fetchFromGitHub {
    owner = "joalla";
    repo = "discogs_client";
    rev = "v${version}";
    sha256 = "0y553x8rkgmqqg980n62pwdxbp75xalkhlb6k5g0cms42ggy5fsc";
  };

  propagatedBuildInputs = [
    requests
    oauthlib
    python-dateutil
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "discogs_client" ];

  meta = with lib; {
    description = "Unofficial Python API client for Discogs";
    homepage = "https://github.com/joalla/discogs_client";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
