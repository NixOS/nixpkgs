{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # install_requires
  dnspython,
  eventlet,
  kombu,
  mock,
  packaging,
  path,
  pyyaml,
  requests,
  setuptools,
  six,
  werkzeug,
  wrapt,
}:

buildPythonPackage rec {
  pname = "nameko";
  version = "2.14.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J1NXi7Tca5KAGuozTSkwuX37dEhucF7daRmDBqlGjIg=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace-fail "path.py" "path"
  '';

  build-system = [ setuptools ];

  dependencies = [
    dnspython
    eventlet
    kombu
    mock
    packaging
    path
    pyyaml
    requests
    setuptools
    six
    werkzeug
    wrapt
  ];

  # tests depend on RabbitMQ being installed - https://nameko.readthedocs.io/en/stable/contributing.html#running-the-tests
  # and most of the tests are network based
  doCheck = false;

  pythonImportsCheck = [ "nameko" ];

  meta = with lib; {
    description = "Microservices framework that lets service developers concentrate on application logic and encourages testability";
    mainProgram = "nameko";
    homepage = "https://www.nameko.io/";
    changelog = "https://github.com/nameko/nameko/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ siddharthdhakane ];
  };
}
