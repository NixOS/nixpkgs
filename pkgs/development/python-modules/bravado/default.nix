{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # build inputs
  bravado-core,
  monotonic,
  msgpack,
  python-dateutil,
  pyyaml,
  requests,
  simplejson,
  six,
  typing-extensions,
  # check inputs
  pytestCheckHook,
  bottle,
  ephemeral-port-reserve,
  httpretty,
  mock,
}:

buildPythonPackage rec {
  pname = "bravado";
  version = "12.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = "bravado";
    tag = "v${version}";
    hash = "sha256-Bavi3RGysBs2OygGndPt2B7iT2WDaenTespvXGn3uyo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bravado-core
    monotonic
    msgpack
    python-dateutil
    pyyaml
    requests
    simplejson
    six
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    bottle
    ephemeral-port-reserve
    httpretty
    mock
  ];

  pythonImportsCheck = [ "bravado" ];

  pytestFlagsArray = [
    # Avoid 'import file mismatch' error
    "--import-mode=importlib"
  ];

  disabledTestPaths = [
    # fido not currently available on nixpkgs
    "tests/fido_client"
    "tests/integration/fido_client_test.py"
  ]
  # Throws 'PermissionError: [Errno 1] Operation not permitted'
  ++ lib.optional stdenv.hostPlatform.isDarwin "tests/integration/requests_client_test.py";

  meta = {
    description = "Bravado is a python client library for Swagger 2.0 services";
    homepage = "https://github.com/Yelp/bravado";
    changelog = "https://github.com/Yelp/bravado/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      gigahawk
    ];
  };
}
