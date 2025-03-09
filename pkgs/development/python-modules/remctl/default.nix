{
  lib,
  buildPythonPackage,
  pythonOlder,
  remctl-c, # remctl from pkgs, not from pythonPackages
  typing,
}:

buildPythonPackage {
  inherit (remctl-c)
    meta
    pname
    src
    version
    ;
  setSourceRoot = "sourceRoot=$(echo */python)";

  buildInputs = [ remctl-c ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.5") [ typing ];
}
