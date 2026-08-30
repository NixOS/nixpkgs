{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
  tenacity,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiokef";
  version = "0.2.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "basnijholt";
    repo = "aiokef";
    tag = "v${finalAttrs.version}";
    hash = "sha256-afZbMIH3HlamGYSF66S9sVC/z7XrXrZ1KRwgeTNvQFc=";
  };

  build-system = [ setuptools ];

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
