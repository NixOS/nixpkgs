{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nmapthon2";
  version = "0.1.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cblopez";
    repo = "nmapthon2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4Na75TdKDywUomJF4tDWUWwCCtcOSxBUMOF7+FDhbpY=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/scanner_tests.py" ];

  pythonImportsCheck = [ "nmapthon2" ];

  meta = {
    description = "Python library to automate nmap";
    homepage = "https://github.com/cblopez/nmapthon2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
