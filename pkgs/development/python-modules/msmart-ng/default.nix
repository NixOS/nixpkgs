{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  httpx,
  pycryptodome,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "msmart-ng";
  version = "2026.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mill1000";
    repo = "midea-msmart";
    tag = version;
    hash = "sha256-+rZf96QRO0eu3J+JQKaAqUS/ce9NZ7l5DHTUKK465Xw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    httpx
    pycryptodome
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  env.CI = true;

  pythonImportsCheck = [ "msmart" ];

  meta = {
    changelog = "https://github.com/mill1000/midea-msmart/releases/tag/${src.tag}";
    description = "Python library for local control of Midea (and associated brands) smart air conditioners";
    homepage = "https://github.com/mill1000/midea-msmart";
    license = lib.licenses.mit;
    mainProgram = "msmart-ng";
    maintainers = with lib.maintainers; [
      hexa
      emilylange
    ];
  };
}
