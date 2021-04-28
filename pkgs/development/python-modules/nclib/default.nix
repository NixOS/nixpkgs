{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nclib";
  version = "1.0.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kf8x30lrwhijab586i54g70s3sxvm2945al48zj27grj0pagh7g";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "nclib" ];

  meta = with lib; {
    description = "Python module that provides netcat features";
    homepage = "https://nclib.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
