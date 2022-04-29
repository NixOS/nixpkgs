{ lib, buildPythonPackage, isPy27, fetchPypi, pytest, pytestCheckHook }:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "ci-info";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "05j6pamk8sd51qmvpkl3f7sxajmncrqm0cz6n6bqgsvzjwn66w6x";
  };

  checkInputs = [ pytest pytestCheckHook ];

  doCheck = false;  # both tests access network

  pythonImportsCheck = [ "ci_info" ];

  meta = with lib; {
    description = "Gather continuous integration information on the fly";
    homepage = "https://github.com/mgxd/ci-info";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
