{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  jq,
  oniguruma,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "jq";
  version = "1.10.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "jq.py";
    tag = version;
    hash = "sha256-1BhRX9OWCfHnelktsrje4ejFxMTpSaGbYuocQ2H4pAI=";
  };

  env.JQPY_USE_SYSTEM_LIBS = 1;

  nativeBuildInputs = [ cython ];

  buildInputs = [
    jq
    oniguruma
  ];

  preBuild = ''
    cython jq.pyx
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # tries to match exact error text, fails with jq 1.8
    "test_value_error_is_raised_if_program_is_invalid"
  ];

  pythonImportsCheck = [ "jq" ];

  meta = {
    description = "Python bindings for jq, the flexible JSON processor";
    homepage = "https://github.com/mwilliamson/jq.py";
    changelog = "https://github.com/mwilliamson/jq.py/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ benley ];
  };
}
