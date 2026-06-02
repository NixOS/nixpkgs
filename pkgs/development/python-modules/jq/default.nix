{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  jq,
  oniguruma,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jq";
  version = "1.11.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "jq.py";
    tag = version;
    hash = "sha256-v5Hi3SkLKX7KrCHiXDuEThSLghDU5VVhNGt1KpMEqC4=";
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
