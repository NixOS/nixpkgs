{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "libpyfoscam";
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FLPerVzx2+3f5biiqt0JHJjBuMIalUBkY+bGb2ShVao=";
  };

  # tests need access to a camera
  doCheck = false;

  pythonImportsCheck = [
    "libpyfoscam"
  ];

  meta = with lib; {
    description = "Python Library for Foscam IP Cameras";
    homepage = "https://github.com/krmarien/python-foscam";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
