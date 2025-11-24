{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  charset-normalizer,
  untokenize,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "docformatter";
  version = "1.7.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "docformatter";
    tag = "v${version}";
    hash = "sha256-eLjaHso1p/nD9K0E+HkeBbnCnvjZ1sdpfww9tzBh0TI=";
  };

  patches = [ ./test-path.patch ];

  postPatch = ''
    substituteInPlace tests/conftest.py \
      --subst-var-by docformatter $out/bin/docformatter
  '';

  build-system = [ poetry-core ];

  dependencies = [
    charset-normalizer
    untokenize
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: assert 'utf_16' == 'latin-1'
    # fixed by https://github.com/PyCQA/docformatter/pull/323
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
