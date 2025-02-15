{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  dawg-python,
  docopt,
  pymorphy2-dicts-ru,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymorphy2";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymorphy2";
    repo = "pymorphy2";
    tag = version;
    hash = "sha256-J7mSq6TY06q06LIRYDwjiHjqXRIxRCX423KOfhK92/U=";
  };

  # fix for python>=3.11
  # https://github.com/pymorphy2/pymorphy2/pull/161
  postPatch = ''
    substituteInPlace pymorphy2/units/base.py \
      --replace-fail "args, varargs, kw, default = inspect.getargspec(cls.__init__)" "args = inspect.getfullargspec(cls.__init__).args"
  '';

  build-system = [ setuptools ];

  dependencies = [
    dawg-python
    docopt
    pymorphy2-dicts-ru
  ];

  pythonImportsCheck = [ "pymorphy2" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # AssertionError
    "test_has_parse"
    "test_has_parse_title"
    "test_has_parse_upper"
    "test_has_proper_lexemes"
    "test_normal_forms"
    "test_threading_multiple_morph_analyzers"
    "test_threading_single_morph_analyzer"
  ];

  meta = {
    description = "Morphological analyzer/inflection engine for Russian and Ukrainian";
    mainProgram = "pymorphy";
    homepage = "https://github.com/kmike/pymorphy2";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
