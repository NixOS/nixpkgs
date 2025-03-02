{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,
  hatch-vcs,

  # tests
  numpy,
  pandas,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "param";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "holoviz";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-3aqABliOk+JtR84J/qiwda4yAkVgG2lJWewhQuSUgtA=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    numpy
    pandas
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  pythonImportsCheck = [ "param" ];

  meta = with lib; {
    description = "Declarative Python programming using Parameters";
    homepage = "https://param.holoviz.org/";
    changelog = "https://github.com/holoviz/param/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
