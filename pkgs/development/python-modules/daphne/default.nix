{
  lib,
  stdenv,
  asgiref,
  autobahn,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  fetchpatch2,
  hypothesis,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  twisted,
}:

buildPythonPackage rec {
  pname = "daphne";
  version = "4.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "django";
    repo = "daphne";
    rev = "refs/tags/${version}";
    hash = "sha256-RAK2CaKKVmVIv1MBK+9xyADOrHq664MQOry4KaGTNCw=";
  };

  patches = [
    # https://github.com/django/daphne/pull/526
    (fetchpatch2 {
      name = "fix-tests-with-Twisted-24.7.0.patch";
      url = "https://github.com/django/daphne/commit/0370c7a0937011d5345b14d484ec171d3ae9f875.patch";
      hash = "sha256-/3d2pRcEtGvINGHRQF3RZ8IVIETSZb6rhf+ZHUFSQQo=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "pytest-runner" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    asgiref
    autobahn
    twisted
  ] ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [
    django
    hypothesis
    pytest-asyncio
    pytestCheckHook
  ];

  # Most tests fail on darwin
  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [ "daphne" ];

  meta = with lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    homepage = "https://github.com/django/daphne";
    changelog = "https://github.com/django/daphne/blob/${version}/CHANGELOG.txt";
    license = licenses.bsd3;
    maintainers = [ ];
    mainProgram = "daphne";
  };
}
