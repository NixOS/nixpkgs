{ buildPythonPackage
, flit
, flit-core
, pytestCheckHook
, testpath
}:

buildPythonPackage {
  pname = "flit-core";
  inherit (flit-core) version;

  src = flit-core.testsout;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    flit
    pytestCheckHook
    testpath
  ];
}
