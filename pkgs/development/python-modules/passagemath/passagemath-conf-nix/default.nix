{
  buildPythonPackage,
  lib,
  setuptools,
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

  meta = {
    description = "Nix specific's `passagemath-conf` implementation";
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
  };
}
