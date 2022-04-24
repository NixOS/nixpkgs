{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cement";
  version = "3.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fccec41eab3f15a03445b1ce24c8a7e106d4d5520f6507a7145698ce68923d31";
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
