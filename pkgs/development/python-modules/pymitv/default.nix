{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pymitv";
  version = "1.4.3";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jbs1zhqpnsyad3pd8cqy1byv8m5bq17ydc6crmrfkjbp6xvvg3x";
  };

  propagatedBuildInputs = [ requests ];

  # Projec thas no tests
  doCheck = false;
  pythonImportsCheck = [ "pymitv" ];

  meta = with lib; {
    description = "Python client the Mi Tv 3";
    homepage = "https://github.com/simse/pymitv";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
