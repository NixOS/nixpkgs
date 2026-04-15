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
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NiaOrg";
    repo = "NiaPy";
    tag = "v${version}";
    hash = "sha256-5Cxxug/FyucU+MkWXMtH43AembfZ/kj5r8nId5664z8=";
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

  meta = {
    description = "Micro framework for building nature-inspired algorithms";
    homepage = "https://niapy.org/";
    changelog = "https://github.com/NiaOrg/NiaPy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
