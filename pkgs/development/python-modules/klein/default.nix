{ lib, buildPythonPackage, fetchPypi
, six, twisted, werkzeug, incremental
, mock }:

buildPythonPackage rec {
  pname = "klein";
  version = "17.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "30aaf0d78a987d5dbfe0968a07367ad0c73e02823cc8eef4c54f80ab848370d0";
  };

  propagatedBuildInputs = [ six twisted werkzeug incremental ];

  checkInputs = [ mock ];

  checkPhase = ''
    trial klein
  '';

  meta = with lib; {
    description = "Klein Web Micro-Framework";
    homepage    = "https://github.com/twisted/klein";
    license     = licenses.mit;
  };
}
