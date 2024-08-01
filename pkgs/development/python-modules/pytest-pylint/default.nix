{
  lib,
  buildPythonPackage,
  fetchPypi,
  pylint,
  pytest,
  pytestCheckHook,
  pythonOlder,
  toml,
}:

buildPythonPackage rec {
  pname = "pytest-pylint";
  version = "0.21.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iHZLjh1c+hiAkkjgzML8BQNfCMNfCwIi3c/qHDxOVT4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    pylint
    toml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_pylint" ];

  meta = with lib; {
    description = "Pytest plugin to check source code with pylint";
    homepage = "https://github.com/carsongee/pytest-pylint";
    license = licenses.mit;
    maintainers = [ ];
  };
}
