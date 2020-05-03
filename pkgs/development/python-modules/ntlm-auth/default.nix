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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = "ntlm-auth";
    rev = "v${version}";
    sha256 = "168k3ygwbvnfcwn7q1nv3vvy6b9jc4cnpix0xgg5j8av7v1x0grn";
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
