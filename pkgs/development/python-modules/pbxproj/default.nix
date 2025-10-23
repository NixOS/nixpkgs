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
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kronenthaler";
    repo = "mod-pbxproj";
    tag = version;
    hash = "sha256-A7kYjlMr0PDZHdZLhs7Mn2Ihx0XKQUbVaRgWcMoWM7E=";
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
