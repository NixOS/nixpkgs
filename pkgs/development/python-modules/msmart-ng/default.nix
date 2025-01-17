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
  version = "2025.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mill1000";
    repo = "midea-msmart";
    tag = version;
    hash = "sha256-+rYIxo8iwCbntg9m8d0R/tCS72s3422jEiELp2F8jJA=";
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

  disabledTestPaths = [
    # network access
    "msmart/tests/test_cloud.py"
  ];

  pythonImportsCheck = [ "msmart" ];

  meta = with lib; {
    changelog = "https://github.com/mill1000/midea-msmart/releases/tag/${version}";
    description = "Python library for local control of Midea (and associated brands) smart air conditioners";
    homepage = "https://github.com/mill1000/midea-msmart";
    license = licenses.mit;
    mainProgram = "msmart-ng";
    maintainers = with maintainers; [
      hexa
      emilylange
    ];
  };
}
