{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytest
, unittest2
, six
}:

buildPythonPackage rec {
  pname = "ntlm-auth";
  version = "1.0.3";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = "ntlm-auth";
    rev = "v${version}";
    sha256 = "09f2g4ivfi9lh1kr30hlg0q4n2imnvmd79w83gza11q9nmhhiwpz";
  };

  checkInputs = [ mock pytest unittest2 ];
  propagatedBuildInputs = [ six ];

  # Functional tests require networking
  checkPhase = ''
    py.test --ignore=tests/functional/test_iis.py
  '';

  meta = with lib; {
    description = "Calculates NTLM Authentication codes";
    homepage = https://github.com/jborean93/ntlm-auth;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ elasticdog ];
    platforms = platforms.all;
  };
}
