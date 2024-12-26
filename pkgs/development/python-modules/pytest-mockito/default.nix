{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  mockito,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-mockito";
  version = "0.0.4";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kaste";
    repo = "pytest-mockito";
    rev = version;
    hash = "sha256-vY/i1YV1lo4mZvnxsXBOyaq31YTiF0BY6PTVwdVX10I=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ mockito ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Base fixtures for mockito";
    homepage = "https://github.com/kaste/pytest-mockito";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
