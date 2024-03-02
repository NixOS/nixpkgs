{ lib
, buildPythonPackage
, linien-common
, linien-client
, pytestCheckHook
}:

buildPythonPackage {
  pname = "linien-tests";
  inherit (linien-common) version src;
  format = "other";
  pyproject = false;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    linien-common
    linien-client
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';
}
