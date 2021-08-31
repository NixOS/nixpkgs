{ buildPythonPackage
, pytestCheckHook
, attrs
, hypothesis
}:

buildPythonPackage {
  pname = "attrs-tests";
  inherit (attrs) version;

  srcs = attrs.testout;

  dontBuild = true;
  dontInstall = true;

  checkInputs = [
    attrs
    hypothesis
    pytestCheckHook
  ];
}
