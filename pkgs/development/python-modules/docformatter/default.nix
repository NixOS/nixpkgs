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
  version = "1.7.5";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-QUjeG84KwI5Y3MU1wrmjHBXU2tEJ0CuiR3Y/S+dX7Gs=";
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

  # Disable failing tests until https://github.com/PyCQA/docformatter/issues/274 is fixed upstream
  disabledTests = [
    "test_do_format_code.py"
    "test_docformatter.py"
  ];

  pythonImportsCheck = [ "docformatter" ];

  meta = {
    changelog = "https://github.com/PyCQA/docformatter/blob/${src.rev}/CHANGELOG.md";
    description = "Formats docstrings to follow PEP 257";
    mainProgram = "docformatter";
    homepage = "https://github.com/myint/docformatter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
