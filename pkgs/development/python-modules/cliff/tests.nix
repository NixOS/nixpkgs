{
  buildPythonPackage,
  cliff,
  sphinx,
  stestrCheckHook,
}:

buildPythonPackage {
  pname = "cliff";
  inherit (cliff) version src;
  pyproject = false;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    cliff
    sphinx
    stestrCheckHook
  ];
}
