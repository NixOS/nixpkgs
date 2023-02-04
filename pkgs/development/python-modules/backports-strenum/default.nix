{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, python
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "backports-strenum";
  version = "1.2.4";

  disabled = pythonAtLeast "3.11";

  src = fetchPypi {
    inherit version;
    pname = "backports.strenum";
    sha256 = "sha256-h7Z/0UE6886Vm1ZdhN3vmXds3ZemLi/S0FUM2swhDe4=";
  };

  propagatedBuildInputs = [
    setuptools-scm
  ];

  pythonImportsCheck = [ "backports.strenum" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Backport of the standard library module strenum";
    homepage = "https://github.com/clbarnes/backports.strenum";
    license = licenses.psfl;
    maintainers = with maintainers; [ ppentchev ];
  };
}
