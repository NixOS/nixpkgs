{
  aenum,
  buildPythonPackage,
  fetchFromGitHub,
  frozendict,
  lib,
  pydantic_1,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "onelogin";
  version = "3.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onelogin";
    repo = "onelogin-python-sdk";
    rev = version;
    hash = "sha256-4REMLFMVDTEu0BpxhlF8nfXGLW8/UwoejXVT4P7jTuo=";
  };

  nativeBuildInputs = [ setuptools ];

  build-system = [
    setuptools
  ];

  dependencies = [
    aenum
    frozendict
    python-dateutil
    pydantic_1
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "onelogin" ];

  meta = with lib; {
    description = "OpenAPI Specification for OneLogin";
    homepage = "https://github.com/onelogin/onelogin-python-sdk";
    license = licenses.mit;
    maintainers = with maintainers; [ gjhenrique ];
  };
}
