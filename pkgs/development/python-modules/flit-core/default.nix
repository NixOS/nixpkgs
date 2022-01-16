{ lib
, buildPythonPackage
, callPackage
, flit
}:

# This is a package for bootstrapping the Python packages set.
# What is passed to `src` needs to have already been unpacked.

buildPythonPackage rec {
  pname = "flit-core";
  inherit (flit) version;
  format = "pyproject";

  outputs = [
    "out"
    "testsout"
  ];

  inherit (flit) src patches;

  preConfigure = ''
    cd flit_core
  '';

  postInstall = ''
    mkdir $testsout
    cp -R ../tests $testsout/tests
  '';

  # check in passthru.tests.pytest to escape infinite recursion with setuptools-scm
  doCheck = false;

  passthru.tests = {
    inherit flit;
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Distribution-building parts of Flit. See flit package for more information";
    homepage = "https://github.com/pypa/flit";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh SuperSandro2000 ];
  };
}
