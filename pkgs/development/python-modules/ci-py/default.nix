{ lib, buildPythonPackage, fetchPypi, isPy27
, pytest, pytest-runner, pytestCheckHook }:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "ci-py";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "12ax07n81vxbyayhwzi1q6x7gfmwmvrvwm1n4ii6qa6fqlp9pzj7";
  };

  nativeBuildInputs = [ pytest-runner ];  # pytest-runner included in setup-requires
  nativeCheckInputs = [ pytest pytestCheckHook ];

  pythonImportsCheck = [ "ci" ];

  meta = with lib; {
    description = "Library for working with Continuous Integration services";
    homepage = "https://github.com/grantmcconnaughey/ci.py";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
