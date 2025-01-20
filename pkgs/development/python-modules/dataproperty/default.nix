{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-IEEwdOcC9nKwVumWnjpZlqYKCFGwZebMh7nGdGVjibE=";
  };

  propagatedBuildInputs = [
    mbstrdecoder
    typepy
    tcolorpy
  ] ++ typepy.optional-dependencies.datetime;

  optional-dependencies = {
    logging = [ loguru ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    termcolor
  ];

  pythonImportsCheck = [ "dataproperty" ];

  meta = with lib; {
    description = "Library for extracting properties from data";
    homepage = "https://github.com/thombashi/dataproperty";
    changelog = "https://github.com/thombashi/DataProperty/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ genericnerdyusername ];
  };
}
