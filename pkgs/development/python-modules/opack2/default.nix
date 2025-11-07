{
  arrow,
  buildPythonPackage,
  construct,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "opack2";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doronz88";
    repo = "opack2";
    tag = "v${version}";
    hash = "sha256-7kRR4KOR3Wrya2YE8nL5laXrsnI1lSVZMBEij44J+T0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    arrow
    construct
  ];

  pythonImportsCheck = [ "opack2" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/doronz88/opack2/releases/tag/${src.tag}";
    description = "Python library for parsing the opack format";
    homepage = "https://github.com/doronz88/opack2";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
