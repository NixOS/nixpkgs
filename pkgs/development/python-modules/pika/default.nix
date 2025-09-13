{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  gevent,
  twisted,
  tornado,

  # tests
  nose2,
  mock,

}:

buildPythonPackage rec {
  pname = "pika";
  version = "1.4.0b0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pika";
    repo = "pika";
    tag = version;
    hash = "sha256-c9pnVrrxH/kwTuOHjWFZrvg3KeHkJtOUyNltQ1vOMVg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    gevent
    tornado
    twisted
  ];

  nativeCheckInputs = [
    nose2
    mock
  ];

  postPatch = ''
    # don't stop at first test failure
    # don't run acceptance tests because they access the network
    # don't report test coverage
    substituteInPlace nose2.cfg \
      --replace "stop = 1" "stop = 0" \
      --replace "tests=tests/unit,tests/acceptance" "tests=tests/unit" \
      --replace "with-coverage = 1" "with-coverage = 0"
  '';

  doCheck = false; # tests require rabbitmq instance, unsure how to skip

  checkPhase = ''
    runHook preCheck

    PIKA_TEST_TLS=true nose2 -v

    runHook postCheck
  '';

  meta = with lib; {
    changelog = "https://github.com/pika/pika/releases/tag/${version}";
    description = "Pure-Python implementation of the AMQP 0-9-1 protocol";
    downloadPage = "https://github.com/pika/pika";
    homepage = "https://pika.readthedocs.org";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
