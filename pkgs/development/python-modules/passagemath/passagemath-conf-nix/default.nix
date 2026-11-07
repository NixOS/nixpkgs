{
  buildPythonPackage,
  setuptools,
  writeText,
  ...
}:
let
  pname = "passagemath-conf";
  version = "10.8.13.0";
in
buildPythonPackage {
  inherit pname version;

  pyproject = true;
  src = ./sage-conf;
  build-system = [
      setuptools
    ];
}
