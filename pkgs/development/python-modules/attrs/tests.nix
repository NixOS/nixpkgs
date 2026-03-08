{
  buildPythonPackage,
  pytestCheckHook,
  attrs,
  hypothesis,
}:

buildPythonPackage {
  pname = "attrs-tests";
  inherit (attrs) version;
  pyproject = false;

  srcs = attrs.testout;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    attrs
    hypothesis
    pytestCheckHook
  ];
}
