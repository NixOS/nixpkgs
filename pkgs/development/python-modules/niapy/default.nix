{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  numpy,
  openpyxl,
  pandas,
  poetry-core,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "niapy";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NiaOrg";
    repo = "NiaPy";
    tag = "v${version}";
    hash = "sha256-o/JHFPsYMHxSkUMfRbR3SJawbzTsoh6ae0pyxLd1bAs=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    matplotlib
    numpy
    openpyxl
    pandas
  ];

  pythonRelaxDeps = [
    "numpy"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  pythonImportsCheck = [ "niapy" ];

  meta = with lib; {
    description = "Micro framework for building nature-inspired algorithms";
    homepage = "https://niapy.org/";
    changelog = "https://github.com/NiaOrg/NiaPy/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
