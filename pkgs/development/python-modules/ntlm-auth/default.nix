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
  version = "1.0.4";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = "ntlm-auth";
    rev = "v${version}";
    sha256 = "3d411413f1309fcd443095d57ab169b637e5b57ce701ac7ae8dbf572cb3533c0";
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
