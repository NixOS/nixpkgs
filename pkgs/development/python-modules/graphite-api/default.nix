{ stdenv, buildPythonPackage, fetchFromGitHub, lib, flask, flask-caching, cairocffi, pyparsing, pytz, pyyaml
, raven, six, structlog, tzlocal, nose, mock, cairo, isPyPy
}:

buildPythonPackage rec {
  pname = "graphite-api";
  version = "1.1.3";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "brutasse";
    repo = "graphite-api";
    rev = version;
    sha256 = "0sz3kav2024ms2z4q03pigcf080gsr5v774z9bp3zw29k2p47ass";
  };

  # https://github.com/brutasse/graphite-api/pull/239 rebased onto 1.1.3
  patches = [ ./flask-caching-rebased.patch ];

  checkPhase = "nosetests";

  propagatedBuildInputs = [
    flask
    flask-caching
    cairocffi
    pyparsing
    pytz
    pyyaml
    raven
    six
    structlog
    tzlocal
  ];

  checkInputs = [ nose mock ];

  LD_LIBRARY_PATH = "${cairo.out}/lib";

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Graphite-web, without the interface. Just the rendering HTTP API";
    homepage = "https://github.com/brutasse/graphite-api";
    license = licenses.asl20;
  };
}
