{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  unittestCheckHook,
  lxml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gpxpy";
  version = "1.6.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "tkrajina";
    repo = "gpxpy";
    rev = "v${version}";
    hash = "sha256-s65k0u4LIwHX9RJMJIYMkNS4/Z0wstzqYVPAjydo2iI=";
  };

  build-system = [ setuptools ];

  dependencies = [ lxml ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Python GPX (GPS eXchange format) parser";
    mainProgram = "gpxinfo";
    homepage = "https://github.com/tkrajina/gpxpy";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
