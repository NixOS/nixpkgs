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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "niapy";
  version = "2.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "NiaOrg";
    repo = "NiaPy";
    rev = "refs/tags/v${version}";
    hash = "sha256-cT5CU1r3LZ9ValJwRUA0PaISmF6kXAz40alXbWYogGA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    matplotlib
    numpy
    openpyxl
    pandas
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "niapy" ];

  meta = with lib; {
    description = "Micro framework for building nature-inspired algorithms";
    homepage = "https://niapy.org/";
    changelog = "https://github.com/NiaOrg/NiaPy/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
