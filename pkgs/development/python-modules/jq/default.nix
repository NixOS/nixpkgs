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
  version = "1.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "jq.py";
    tag = version;
    hash = "sha256-xzkOWIMvGBVJtdZWFFIQkfgTivMTxV+dze71E8S6SlM=";
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

  meta = with lib; {
    description = "Python bindings for jq, the flexible JSON processor";
    homepage = "https://github.com/mwilliamson/jq.py";
    changelog = "https://github.com/mwilliamson/jq.py/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ benley ];
  };
}
