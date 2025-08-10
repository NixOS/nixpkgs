{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  loguru,
  mbstrdecoder,
  pytestCheckHook,
  pythonOlder,
  tcolorpy,
  termcolor,
  typepy,
}:

buildPythonPackage rec {
  pname = "dataproperty";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "dataproperty";
    tag = "v${version}";
    hash = "sha256-IEEwdOcC9nKwVumWnjpZlqYKCFGwZebMh7nGdGVjibE=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    mbstrdecoder
    typepy
    tcolorpy
  ]
  ++ typepy.optional-dependencies.datetime;

  optional-dependencies = {
    logging = [ loguru ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    termcolor
  ];

  pythonImportsCheck = [ "dataproperty" ];

  meta = {
    description = "Library for extracting properties from data";
    homepage = "https://github.com/thombashi/DataProperty";
    changelog = "https://github.com/thombashi/DataProperty/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genericnerdyusername ];
  };
}
