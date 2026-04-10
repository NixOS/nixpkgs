{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "decorator";
  version = "5.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "micheles";
    repo = "decorator";
    tag = version;
    hash = "sha256-whGT0XDVdo0mhc2KP5unjdUSP3AFWKql1fKM1qlK/Zc=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "decorator" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/test.py" ];

  meta = {
    changelog = "https://github.com/micheles/decorator/blob/${src.tag}/CHANGES.md";
    homepage = "https://github.com/micheles/decorator";
    description = "Better living through Python with decorators";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
