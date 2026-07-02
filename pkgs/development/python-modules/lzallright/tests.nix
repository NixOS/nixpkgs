{
  lzallright,
  buildPythonPackage,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (lzallright) version src;
  pname = "lzallright-tests";
  pyproject = false;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    lzallright
    pytestCheckHook
  ];
}
