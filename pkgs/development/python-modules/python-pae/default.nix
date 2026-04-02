{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-pae";
  version = "0.1.0";
  pyproject = true;

  # Tests are on GitHub
  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "python-pae";
    rev = version;
    hash = "sha256-D0X2T0ze79KR6Gno4UWpA/XvlkK6Y/jXUtLbzlOKr3E=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "python_pae" ];

  meta = {
    description = "Pre-authentication encoding (PAE) implementation in Python";
    homepage = "https://github.com/MatthiasValvekens/python-pae";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
