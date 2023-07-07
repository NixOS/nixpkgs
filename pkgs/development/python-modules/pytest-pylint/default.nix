{ lib
, buildPythonPackage
, fetchPypi
, pylint
, pytest
, pytestCheckHook
, pythonOlder
, toml
}:

buildPythonPackage rec {
  pname = "pytest-pylint";
  version = "0.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2I6DwQI8ZBVIqew1Z3B87udhZjKphq8TNCbUp00GaTI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    pylint
    toml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_pylint"
  ];

  meta = with lib; {
    description = "Pytest plugin to check source code with pylint";
    homepage = "https://github.com/carsongee/pytest-pylint";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
