{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  version = "0.3.3";
  pname = "ofxhome";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "captin411";
    repo = "ofxhome";
    rev = "v${version}";
    hash = "sha256-i16bE9iuafhAKco2jYfg5T5QCWFHdnYVztf1z2XbO9g=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # These are helper functions that should not be called as tests
  disabledTests = [
    "testfile_name"
    "testfile"
  ];

  meta = {
    homepage = "https://github.com/captin411/ofxhome";
    description = "ofxhome.com financial institution lookup REST client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
