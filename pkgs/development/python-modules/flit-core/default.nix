{ lib
, buildPythonPackage
<<<<<<< HEAD
=======
, callPackage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, flit
}:

buildPythonPackage rec {
  pname = "flit-core";
  inherit (flit) version;
  format = "pyproject";

<<<<<<< HEAD
  inherit (flit) src patches;

  sourceRoot = "source/flit_core";

  # Tests are run in the "flit" package.
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = false;

  passthru.tests = {
    inherit flit;
<<<<<<< HEAD
=======
    pytest = callPackage ./tests.nix { };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "Distribution-building parts of Flit. See flit package for more information";
    homepage = "https://github.com/pypa/flit";
<<<<<<< HEAD
    changelog = "https://github.com/pypa/flit/blob/${src.rev}/doc/history.rst";
    license = licenses.bsd3;
    maintainers = teams.python.members;
=======
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
