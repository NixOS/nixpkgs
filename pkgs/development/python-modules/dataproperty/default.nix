{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  loguru,
  mbstrdecoder,
  pytestCheckHook,
  tcolorpy,
  termcolor,
  typepy,
}:

buildPythonPackage rec {
  pname = "dataproperty";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "dataproperty";
    tag = "v${version}";
    hash = "sha256-PLXF9g0VIkmsRLl5+KvXcbbwVwaJSYjWB7l8xz1mPZM=";
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
    maintainers = [ ];
  };
}
