{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytest
, kerberos
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
    sha256 = "10gabhhg3rgacd5ahmi2r128z99fzbrbx6mz1nnq0dxmhmn5rpjf";
  };

  checkInputs = [ mock pytest ];
  propagatedBuildInputs = [
    kerberos
    requests
    requests_ntlm
    six
    xmltodict
  ];

  meta = with lib; {
    description = "Python library for Windows Remote Management";
    homepage = https://github.com/diyan/pywinrm/;
    license = licenses.mit;
    maintainers = with maintainers; [ elasticdog ];
    platforms = platforms.all;
  };
}
