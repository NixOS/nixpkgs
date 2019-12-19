{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytest
, requests
, requests_ntlm
, six
, xmltodict
}:

buildPythonPackage rec {
  pname = "pywinrm";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ede5c6c85b53780ad0dbf9abef2fa2ea58f44c82256a84a63eae5f1205cea81";
  };

  checkInputs = [ mock pytest ];
  propagatedBuildInputs = [ requests requests_ntlm six xmltodict ];

  meta = with lib; {
    description = "Python library for Windows Remote Management";
    homepage = https://github.com/diyan/pywinrm/;
    license = licenses.mit;
    maintainers = with maintainers; [ elasticdog ];
    platforms = platforms.all;
  };
}
