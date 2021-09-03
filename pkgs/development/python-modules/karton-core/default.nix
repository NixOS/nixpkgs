{ lib
, buildPythonPackage
, fetchFromGitHub
, minio
, python
, redis
}:

buildPythonPackage rec {
  pname = "karton-core";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton";
    rev = "v${version}";
    sha256 = "08j1bm9g58576sswcrpfczaki24nlqqaypp7qv1rxxwsyp5pq6h6";
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
