{ lib
, buildPythonPackage
, fetchPypi
, pyopenssl
, pytest
}:

buildPythonPackage rec {
  pname = "certauth";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lgsl053bbf1xjvwv7q8rhccg1jxzkya222pgkxdcjaa471s9l27";
  };

  propagatedBuildInputs = [ pyopenssl ];

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Certificate authority library for dynamically generating host certs";
    homepage = https://github.com/ikreymer/certauth;
    license = licenses.mit;
    maintainers = with maintainers; [ ivan ];
  };
}
