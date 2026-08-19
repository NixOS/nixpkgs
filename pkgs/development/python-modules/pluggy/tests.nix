{
  buildPythonPackage,
  pluggy,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "pluggy-tests";
  inherit (pluggy) version;
  pyproject = false;

  inherit (pluggy) src;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    pluggy
    pytestCheckHook
  ];
}
