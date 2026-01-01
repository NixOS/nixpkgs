{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pykira";
  version = "0.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MMjmA5N9Ms40eJP9fDDq+LIoPduAnqVrbNLXm+Vl5qw=";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pykira" ];

<<<<<<< HEAD
  meta = {
    description = "Python module to interact with Kira modules";
    homepage = "https://github.com/stu-gott/pykira";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python module to interact with Kira modules";
    homepage = "https://github.com/stu-gott/pykira";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
