{
  lib,
  buildPythonPackage,
  pythonOlder,
}:

buildPythonPackage {

  pname = "typeddep";
  version = "1.3.3.7";
  format = "setuptools";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./setup.py
      ./typeddep
    ];
  };

  disabled = pythonOlder "3.7";

}
