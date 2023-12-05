{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cement";
  version = "3.0.8";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rRGmlGZeKtKEV8VgSU9PjDaiX8WOUA1gip2R4E4dMJM=";
  };

  # Disable test tests since they depend on a memcached server running on
  # 127.0.0.1:11211.
  doCheck = false;

  pythonImportsCheck = [
    "cement"
  ];

  meta = with lib; {
    description = "CLI Application Framework for Python";
    homepage = "https://builtoncement.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eqyiel ];
  };
}
