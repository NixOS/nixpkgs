{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, mock
, pytestCheckHook
, requests
, six
}:

buildPythonPackage rec {
  pname = "ntlm-auth";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = "ntlm-auth";
    rev = "v${version}";
    sha256 = "00dpf5bfsy07frsjihv1k10zmwcyq4bvkilbxha7h6nlwpcm2409";
  };

  propagatedBuildInputs = [
    cryptography
    six
  ];

  checkInputs = [
    mock
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "ntlm_auth" ];

  meta = with lib; {
    description = "Calculates NTLM Authentication codes";
    homepage = "https://github.com/jborean93/ntlm-auth";
    license = licenses.mit;
    maintainers = with maintainers; [ elasticdog ];
    platforms = platforms.all;
  };
}
