{ buildPythonPackage
, callPackage
, flit
}:

buildPythonPackage {
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

  meta = {
    description = "Distribution-building parts of Flit. See flit package for more information";
    inherit (flit.meta) homepage changelog license maintainers;
  };
}
