{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "decorator";
  version = "5.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "micheles";
    repo = "decorator";
    tag = version;
    hash = "sha256-UBjZ8LdgJ6iLBjNTlA3up0qAVBqTSZMJt7oEhUo3ZEo=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "decorator" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/test.py " ];

  meta = with lib; {
    changelog = "https://github.com/micheles/decorator/blob/${src.tag}/CHANGES.md";
    homepage = "https://github.com/micheles/decorator";
    description = "Better living through Python with decorators";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
