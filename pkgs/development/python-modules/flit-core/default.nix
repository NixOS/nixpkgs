{ lib
, buildPythonPackage
, callPackage
, flit
, toml
, pytestCheckHook
, testpath
}:

buildPythonPackage rec {
  pname = "flit-core";
  version = "3.2.0";
  format = "pyproject";

  outputs = [
    "out"
    "testsout"
  ];

  inherit (flit) src patches;

  preConfigure = ''
    cd flit_core
  '';

  propagatedBuildInputs = [
    toml
  ];

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
    homepage = "https://github.com/takluyver/flit";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh SuperSandro2000 ];
  };
}
