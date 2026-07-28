{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "restrictedpython";
  version = "8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "RestrictedPython";
    tag = version;
    hash = "sha256-Ck5YDtjYs7rZk+MC+eKrQVCQX1EYlxC6m4kD5+QjfjE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools >= 78.1.1,< 82" setuptools
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "RestrictedPython" ];

  meta = {
    description = "Restricted execution environment for Python to run untrusted code";
    homepage = "https://github.com/zopefoundation/RestrictedPython";
    changelog = "https://github.com/zopefoundation/RestrictedPython/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
