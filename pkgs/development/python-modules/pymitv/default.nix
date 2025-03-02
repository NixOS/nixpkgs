{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pymitv";
  version = "1.5.0";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0n4IS5W3nvYwKdl6FVf4upRrFDGdYHohsaXadFy8d8w=";
  };

  propagatedBuildInputs = [ requests ];

  # Project thas no tests
  doCheck = false;
  pythonImportsCheck = [ "pymitv" ];

  meta = with lib; {
    description = "Python client the Mi Tv 3";
    homepage = "https://github.com/simse/pymitv";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
