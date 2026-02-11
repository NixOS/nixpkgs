{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  pythonAtLeast,
  tenacity,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiokef";
  version = "0.2.17";
  pyproject = true;

  disabled = pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "basnijholt";
    repo = "aiokef";
    tag = "v${version}";
    hash = "sha256-afZbMIH3HlamGYSF66S9sVC/z7XrXrZ1KRwgeTNvQFc=";
  };

  build-system = [
    setuptools
  ];

  postPatch = ''
    substituteInPlace tox.ini \
      --replace "--mypy" ""
  '';

  dependencies = [
    async-timeout
    tenacity
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  enabledTestPaths = [ "tests" ];
  pythonImportsCheck = [ "aiokef" ];

  meta = {
    description = "Python API for KEF speakers";
    homepage = "https://github.com/basnijholt/aiokef";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
