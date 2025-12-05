{
  lib,
  buildPythonPackage,
  defusedxml,
  flit-core,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  sphinx,
}:

buildPythonPackage rec {
  pname = "breathe";
  version = "5.0.0a5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "breathe-doc";
    repo = "breathe";
    tag = "v${version}";
    hash = "sha256-tCpnjOm3HPsnAtvamqN0weEN5C2bZWTVOTU6YYXrjkI=";
  };

  build-system = [ flit-core ];

  dependencies = [ sphinx ];

  nativeCheckInputs = [
    defusedxml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "breathe" ];

  meta = {
    description = "Sphinx Doxygen renderer";
    mainProgram = "breathe-apidoc";
    homepage = "https://github.com/breathe-doc/breathe";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.sphinx ];
  };
}
