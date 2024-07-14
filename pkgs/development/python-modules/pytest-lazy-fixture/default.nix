{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-lazy-fixture";
  version = "0.6.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Dn0Mf3S6M+boCQXpv9gfnRXvmnkN6XmT40IT3rWtEKw=";
  };

  patches = [
    # fix build with pytest>=8
    # https://github.com/TvoroG/pytest-lazy-fixture/issues/65#issuecomment-1915829980
    ./pytest-8-compatible.patch
  ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pytest_lazyfixture" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Helps to use fixtures in pytest.mark.parametrize";
    homepage = "https://github.com/tvorog/pytest-lazy-fixture";
    license = licenses.mit;
    maintainers = with maintainers; [ tobim ];
  };
}
