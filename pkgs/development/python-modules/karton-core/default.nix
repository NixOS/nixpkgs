{ lib
, buildPythonPackage
, fetchFromGitHub
, minio
, python
, redis
}:

buildPythonPackage rec {
  pname = "karton-core";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-smgKrFexuL0bgt/1Ikm1tpSGPJNJm7Ko68iZn3AQw5E=";
  };

  propagatedBuildInputs = [ minio redis ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover
    runHook postCheck
  '';

  meta = with lib; {
    description = "Distributed malware processing framework";
    homepage = "https://karton-core.readthedocs.io/";
    maintainers = with maintainers; [ chivay ];
    license = licenses.bsd3;
  };
}
