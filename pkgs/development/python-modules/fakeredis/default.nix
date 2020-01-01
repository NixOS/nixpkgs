{ lib
, buildPythonPackage
, fetchFromGitHub
, redis
, six
, sortedcontainers
, lupa
, pytest
, hypothesis
}:

buildPythonPackage rec {
  pname = "fakeredis";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "jamesls";
    repo = "fakeredis";
    rev = version;
    sha256 = "0j2y7mxdp63ida5f5l9hc75sjz1rqdz2dm4zairg0aksqrz197qa";
  };

  propagatedBuildInputs = [
    redis
    six
    sortedcontainers
    lupa
  ];

  checkInputs = [
    pytest
    hypothesis
  ];

  checkPhase = ''
    pytest -x
  '';

  meta = with lib; {
    description = "Fake implementation of redis API for testing purposes";
    homepage = https://github.com/jamesls/fakeredis;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
