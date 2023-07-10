{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyjwt";
  version = "2.4.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PyJWT";
    inherit version;
    sha256 = "sha256-1CkIIIxpmzuXPL6wGpabpqlsgh7vscW/5MOQwB1nq7o=";
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
