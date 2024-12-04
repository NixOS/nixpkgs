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
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "jq.py";
    rev = "refs/tags/${version}";
    hash = "sha256-c6tJI/mPlBGIYTk5ObIQ1CUTq73HouQ2quMZVWG8FFg=";
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
    # intentional behavior change in jq 1.7.1 not reflected upstream
    "test_given_json_text_then_strings_containing_null_characters_are_preserved"
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
