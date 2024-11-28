{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  docopt,
  openstep-parser,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pbxproj";
  version = "4.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kronenthaler";
    repo = "mod-pbxproj";
    rev = "refs/tags/${version}";
    hash = "sha256-srtS6ggVnpffEa57LL2OzfC2mVd9uLxUL6LzxqPVLdo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docopt
    openstep-parser
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "pbxproj"
    "openstep_parser"
  ];

  meta = {
    description = "Python module to manipulate XCode projects ";
    homepage = "https://github.com/kronenthaler/mod-pbxproj";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilaumjd ];
  };
}
