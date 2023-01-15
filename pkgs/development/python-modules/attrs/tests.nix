{ buildPythonPackage
, pytestCheckHook
, attrs
, hypothesis
}:

buildPythonPackage {
  pname = "attrs-tests";
  inherit (attrs) version;
  format = "other";

  srcs = attrs.testout;

  dontBuild = true;
  dontInstall = true;

  checkInputs = [
    attrs
    hypothesis
    pytestCheckHook
  ];
}
