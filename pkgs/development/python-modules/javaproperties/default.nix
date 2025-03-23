{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
}:

buildPythonPackage rec {
  version = "0.8.2";
  pname = "javaproperties";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = "javaproperties";
    tag = "v${version}";
    sha256 = "sha256-8Deo6icInp7QpTqa+Ou6l36/23skxKOYRef2GbumDqo=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    python-dateutil
    pytestCheckHook
  ];

  disabledTests = [ "time" ];

  disabledTestPaths = [ "test/test_propclass.py" ];

  meta = {
    description = "Python library for reading and writing Java .properties files";
    homepage = "https://github.com/jwodder/javaproperties";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
