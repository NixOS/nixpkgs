{ lib
, buildPythonPackage
, callPackage
, flit
, python
}:

# This package uses a bootstrapping process, to escape cyclic
# dependency chains. See
# https://flit.pypa.io/en/latest/bootstrap.html

buildPythonPackage {
  pname = "flit-core";
  inherit (flit) version;
  format = "other";

  outputs = [
    "out"
    "testsout"
  ];

  inherit (flit) src patches;

  preConfigure = ''
    cd flit_core
  '';

  buildPhase = ''
    runHook preBuild
    ${python.interpreter} -m flit_core.wheel
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${python.interpreter} bootstrap_install.py --installdir $out/${python.sitePackages} dist/*.whl
    runHook postInstall
  '';

  postInstall = ''
    mkdir $testsout
    mv ../tests $testsout/tests
  '';

  pythonImportsCheck = [
    "flit_core"
  ];

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
