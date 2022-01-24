{ lib
, buildPythonPackage
, fetchFromGitHub
, minio
, python
, redis
}:

buildPythonPackage rec {
  pname = "karton-core";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton";
    rev = "v${version}";
    sha256 = "sha256-pIYDY+pie4xqH11UHBal7/+MVmJDgNCFVpSD9we9ZPA=";
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
