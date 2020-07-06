{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytest
, requests
, unittest2
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

  checkInputs = [ mock pytest requests unittest2 ];
  propagatedBuildInputs = [ six ];

  # Functional tests require networking
  checkPhase = ''
    py.test --ignore=tests/functional/test_iis.py
  '';

  meta = with lib; {
    description = "Calculates NTLM Authentication codes";
    homepage = "https://github.com/jborean93/ntlm-auth";
    license = licenses.mit;
    maintainers = with maintainers; [ elasticdog ];
    platforms = platforms.all;
  };
}
