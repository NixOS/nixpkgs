{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pykira";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MMjmA5N9Ms40eJP9fDDq+LIoPduAnqVrbNLXm+Vl5qw=";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pykira" ];

  meta = with lib; {
    description = "Python module to interact with Kira modules";
    homepage = "https://github.com/stu-gott/pykira";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
