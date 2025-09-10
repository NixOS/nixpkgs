{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  charset-normalizer,
  tomli,
  untokenize,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "docformatter";
  version = "1.7.7";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "docformatter";
    tag = "v${version}";
    hash = "sha256-eLjaHso1p/nD9K0E+HkeBbnCnvjZ1sdpfww9tzBh0TI=";
  };

  patches = [ ./test-path.patch ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'charset_normalizer = "^2.0.0"' 'charset_normalizer = ">=2.0.0"'
    substituteInPlace tests/conftest.py \
      --subst-var-by docformatter $out/bin/docformatter
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    charset-normalizer
    tomli
    untokenize
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # Disable failing tests until https://github.com/PyCQA/docformatter/issues/274 is fixed upstream
    "test_do_format_code.py"
    "test_docformatter.py"
    # some different issue
    "test_detect_encoding_with_undetectable_encoding"
  ];

  pythonImportsCheck = [ "docformatter" ];

  meta = {
    changelog = "https://github.com/PyCQA/docformatter/blob/${src.tag}/CHANGELOG.md";
    description = "Formats docstrings to follow PEP 257";
    mainProgram = "docformatter";
    homepage = "https://github.com/myint/docformatter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
