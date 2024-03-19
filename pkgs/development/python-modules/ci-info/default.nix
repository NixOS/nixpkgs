{ lib, buildPythonPackage, isPy27, fetchPypi, pytest, pytestCheckHook }:

buildPythonPackage rec {
  version = "0.3.0";
  format = "setuptools";
  pname = "ci-info";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H9UMvUAfKa3/7rGLBIniMtFqwadFisa8MW3qtq5TX7A=";
  };

  nativeCheckInputs = [ pytest pytestCheckHook ];

  doCheck = false;  # both tests access network

  pythonImportsCheck = [ "ci_info" ];

  meta = with lib; {
    description = "Gather continuous integration information on the fly";
    homepage = "https://github.com/mgxd/ci-info";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
