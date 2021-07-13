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
  version = "0.4.2";
  disabled = isPy38;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7865ec5e46e7fedb859c656cfaba4fcf669de7c042b5a7d8a759544636bcfb7";
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
