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
  version = "2024.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mill1000";
    repo = "midea-msmart";
    rev = version;
    hash = "sha256-djo+sINurnrt0GO8045bgNstjh+yl+CE2GJ1vWivAqY=";
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
