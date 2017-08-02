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
  version = "0.2.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06xc0mbqf718vmsp0fq0rb64nql66l5w2x23bmqnzl6nzc0gfc1h";
  };

  checkInputs = [ mock pytest ];
  propagatedBuildInputs = [ requests requests_ntlm six xmltodict ];

  meta = with lib; {
    description = "Python library for Windows Remote Management";
    homepage = http://github.com/diyan/pywinrm/;
    license = licenses.mit;
    maintainers = with maintainers; [ elasticdog ];
    platforms = platforms.all;
  };
}
