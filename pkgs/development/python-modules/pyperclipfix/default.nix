{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage {
  version = "1.9.4-unstable-2024-01-23";
  pname = "pyperclipfix";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AuroraWright";
    repo = "pyperclipfix";
    rev = "8c6c61de35b44ddbc927b37ade5579825db40826"; # no tags
    hash = "sha256-sREtSNEMj0Q+XWQsJu/7u9M1UdiocDq/YkrCPGRLhHA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    substituteInPlace tests/test_pyperclip.py \
      --replace-fail "pyperclip" "pyperclipfix"
  '';

  pythonImportsCheck = [ "pyperclipfix" ];

  # test file is trying to import pyperclip
  doCheck = false;

  meta = {
    homepage = "https://github.com/AuroraWright/pyperclipfix";
    license = lib.licenses.bsd3;
    description = "Cross-platform clipboard module with various fixes";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
