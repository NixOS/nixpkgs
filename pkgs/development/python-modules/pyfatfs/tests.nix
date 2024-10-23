{
  buildPythonPackage,
  pytestCheckHook,
  pyfatfs,
  pytest-mock,
}:

buildPythonPackage {
  pname = "pyfatfs-tests";
  inherit (pyfatfs) version src;
  format = "other";
  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    pyfatfs
    pytestCheckHook
    pytest-mock
  ];
}
