{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  apispec,
  boto3,
  build,
  cachetools,
  click,
  cryptography,
  localstack-client,
  localstack-ext,
  plux,
  psutil,
  python-dotenv,
  pyyaml,
  packaging,
  requests,
  rich,
  semver,
  setuptools,
  setuptools-scm,
  tailer,
}:

buildPythonPackage rec {
  pname = "localstack";
  version = "3.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "localstack";
    rev = "refs/tags/v${version}";
    hash = "sha256-8xdP/qpmfqmXDt1gNhzkAGlBR6dJYznKr9+/Un6N7mA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    apispec
    boto3
    build
    cachetools
    click
    cryptography
    localstack-client
    localstack-ext
    plux
    psutil
    python-dotenv
    pyyaml
    packaging
    requests
    rich
    semver
    tailer
  ];

  pythonRelaxDeps = [ "dill" ];

  pythonImportsCheck = [ "localstack" ];

  # Test suite requires boto, which has been removed from nixpkgs
  # Just do minimal test, buildPythonPackage maps checkPhase
  # to installCheckPhase, so we can test that entrypoint point works.
  checkPhase = ''
    runHook preCheck

    export HOME=$(mktemp -d)
    $out/bin/localstack --version

    runHook postCheck
  '';

  meta = with lib; {
    description = "Fully functional local Cloud stack";
    homepage = "https://github.com/localstack/localstack";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "localstack";
  };
}
