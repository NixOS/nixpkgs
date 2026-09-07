{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  django,
  djangorestframework,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "nested-multipart-parser";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "remigermain";
    repo = "nested-multipart-parser";
    tag = "v${version}";
    hash = "sha256-FFALem8Y43tKL32VSZE1pIlOKEPh5Ryzbu509Xjd+VY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    django
    djangorestframework
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nested_multipart_parser"
  ];

  meta = {
    changelog = "https://github.com/remigermain/nested-multipart-parser/releases/tag/${src.tag}";
    description = "Parser for nested data for 'multipart/form'";
    homepage = "https://github.com/remigermain/nested-multipart-parser";
    license = lib.licenses.mit;
  };
}
