{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  numpy,
  openpyxl,
  pandas,
  poetry-core,
  pytest7CheckHook,
  pytest-xdist,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "niapy";
  version = "2.5.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "NiaOrg";
    repo = "NiaPy";
    tag = "v${version}";
    hash = "sha256-8hKT0WxnJijm22w4DkzicvtikaTL/mL3VhQX/WVHL58=";
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
    pytest7CheckHook
    pytest-xdist
  ];

  pythonImportsCheck = [ "niapy" ];

  meta = with lib; {
    description = "Micro framework for building nature-inspired algorithms";
    homepage = "https://niapy.org/";
    changelog = "https://github.com/NiaOrg/NiaPy/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
