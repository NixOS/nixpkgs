{ lib
, buildPythonPackage
, fetchPypi
, pyserial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioserial";
  version = "1.3.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "080j3ws3j2arj2f16mzqn1qliy0bzmb0gzk5jvm5ldkhsf1s061h";
  };

  propagatedBuildInputs = [
    pyserial
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioserial" ];

  meta = with lib; {
    description = "Python module for async serial communication";
    homepage = "https://github.com/changyuheng/aioserial";
    license = licenses.mpl20;
    maintainers = with maintainers; [ fab ];
  };
}
