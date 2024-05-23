{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "locust";
  version = "2.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "locustio";
    repo = "locust";
    rev = version;
    hash = "sha256-xy4k2stZY1JAxOtyHWfE2KlPAGufTP0un0Pol3Akysg=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.setuptools-scm
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    configargparse
    flask
    flask-cors
    flask-login
    gevent
    geventhttpclient
    msgpack
    psutil
    pyzmq
    requests
    tomli
    werkzeug
  ];

  meta = with lib; {
    description = "Write scalable load tests in plain Python";
    homepage = "https://github.com/locustio/locust";
    changelog = "https://github.com/locustio/locust/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "locust";
  };
}
