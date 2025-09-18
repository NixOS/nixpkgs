{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build dependencies
  flit-core,

  # dependencies
  mdformat,
  wcwidth,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mdformat-tables";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mdformat-tables";
    tag = "v${version}";
    hash = "sha256-7MbpGBGprhGrQ9P31HUU2h0bjyHWap6DETVN/dCDA1w=";
  };

  build-system = [ flit-core ];

  dependencies = [
    mdformat
    wcwidth
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mdformat_tables" ];

  meta = with lib; {
    description = "Mdformat plugin for rendering tables";
    homepage = "https://github.com/executablebooks/mdformat-tables";
    license = licenses.mit;
    maintainers = with maintainers; [
      aldoborrero
      polarmutex
    ];
  };
}
