{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pykira";
  version = "0.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MMjmA5N9Ms40eJP9fDDq+LIoPduAnqVrbNLXm+Vl5qw=";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pykira" ];

  meta = {
    description = "Python module to interact with Kira modules";
    homepage = "https://github.com/stu-gott/pykira";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
