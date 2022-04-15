{ lib
, buildPythonPackage
, fetchPypi
, isPy38
, kerberos
, mock
, pytest
, requests
, requests_ntlm
, six
, xmltodict
}:

buildPythonPackage rec {
  pname = "pywinrm";
  version = "0.4.3";
  disabled = isPy38;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mVZ0v1rGSyViycVlQEcxCeUw02veEMJi1aUpYSGtVWU=";
  };

  checkInputs = [ mock pytest ];
  propagatedBuildInputs = [ requests requests_ntlm six kerberos xmltodict ];

  meta = with lib; {
    description = "Python library for Windows Remote Management";
    homepage = "https://github.com/diyan/pywinrm";
    license = licenses.mit;
    maintainers = with maintainers; [
      elasticdog
      kamadorueda
    ];
    platforms = platforms.all;
  };
}
