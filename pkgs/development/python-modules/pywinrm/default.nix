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
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "799fc3e33fec8684443adf5778860388289102ea4fa1458f1bf307d167855573";
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
