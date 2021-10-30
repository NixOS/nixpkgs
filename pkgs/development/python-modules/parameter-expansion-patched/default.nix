{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "parameter-expansion-patched";
  version = "0.2.1b4";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vhshscjifi78qapzwn29gln6p8jhyc7cccszl8ai2jamhcph5zs";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "parameter_expansion"
  ];

  meta = with lib; {
    description = "POSIX parameter expansion in Python";
    homepage = "https://github.com/nexB/commoncode";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
