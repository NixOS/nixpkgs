{ lib
, buildPythonPackage
, python3Packages
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "locust";
  version = "2.16.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "locustio";
    repo = "locust";
    rev = version;
    hash = "sha256-MKFzEFpDkD8e+ENZN0GAWYipPK9A4SCZZRHG5/5UaNM=";
  };

  patchPhase = ''
     echo 'version = "${version}"' > locust/_version.py
  '';

  propagatedBuildInputs = with python3Packages; [
    requests
    flask-basicauth
    flask-cors
    msgpack
    gevent
    pyzmq
    roundrobin
    geventhttpclient
    psutil
    typing-extensions
    configargparse
    setuptools
  ];

  meta = with lib; {
    description = "A load testing tool";
    homepage = "https://locust.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ shyim ];
  };
}
