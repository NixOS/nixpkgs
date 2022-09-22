{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyjwt";
  version = "2.5.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyJWT";
    inherit version;
    sha256 = "sha256-53q4lICQXYaZhEKsV4jzUzP6hfZQR6U0rcOO3zyI/Ds=";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jwt" ];

  meta = with lib; {
    description = "JSON Web Token implementation in Python";
    homepage = "https://github.com/jpadilla/pyjwt";
    license = licenses.mit;
    maintainers = with maintainers; [ prikhi ];
  };
}
