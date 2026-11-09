{
  buildPythonPackage,
  remctl-c, # remctl from pkgs, not from pythonPackages
}:

buildPythonPackage {
  format = "setuptools";
  inherit (remctl-c)
    meta
    pname
    src
    version
    ;
  setSourceRoot = "sourceRoot=$(echo */python)";

  buildInputs = [ remctl-c ];
}
