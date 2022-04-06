{ lib
, buildPythonPackage
, fetchFromGitHub
, minio
, python
, redis
}:

buildPythonPackage rec {
  pname = "karton-core";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-TwTq44l/Nx+FQ6tFZHat4SPGOmHSwYfg7ShbGnxpkVw=";
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
