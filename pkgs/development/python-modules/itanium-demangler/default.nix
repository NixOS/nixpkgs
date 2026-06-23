{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "itanium-demangler";
  version = "1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "python-itanium_demangler";
    tag = "v${version}";
    hash = "sha256-I6NUfckt2cocQt5dZSFadpshTCuA/6bVNauNXypWh+A=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/test.py" ];

  pythonImportsCheck = [ "itanium_demangler" ];

  meta = {
    description = "Python parser for the Itanium C++ ABI symbol mangling language";
    homepage = "https://github.com/whitequark/python-itanium_demangler";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [
      fab
      pamplemousse
    ];
  };
}
