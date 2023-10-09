{ lib, buildPythonPackage, fetchPypi, flit-core
, bottle, datauri, doreah, jinja2, lru-dict, nimrodel
, psutil, requests, setproctitle, sqlalchemy, waitress,
}:

buildPythonPackage rec {
  pname = "maloja";
  version = "3.1.5";
  format = "pyproject";

  src = fetchPypi {
    pname = "malojaserver";
    inherit version;
    hash = "sha256-n6qT/Xy5d5OP8wVMYUjyRLel89LldV3qIaTVuEVsRDs=";
  };

  nativeBuildInputs = [
    flit-core
  ];
  propagatedBuildInputs = [
    bottle
    datauri
    doreah
    jinja2
    lru-dict
    nimrodel
    psutil
    requests
    setproctitle
    sqlalchemy
    waitress
  ];

  meta = with lib; {
    homepage = "https://github.com/krateng/maloja";
    description = "Self-hosted music scrobble database";
    license = licenses.gpl3;
    maintainers = with maintainers; [ avh4 ];
  };
}
