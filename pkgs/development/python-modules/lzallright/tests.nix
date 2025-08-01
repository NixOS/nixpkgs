{
  lzallright,
  buildPythonPackage,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (lzallright) version src;
  pname = "lzallright-tests";
  format = "other";

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    lzallright
    pytestCheckHook
  ];
}
