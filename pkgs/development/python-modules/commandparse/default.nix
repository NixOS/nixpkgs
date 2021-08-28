{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "commandparse";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06mcxc0vs5qdcywalgyx5zm18z4xcsrg5g0wsqqv5qawkrvmvl53";
  };

  # tests only distributed upstream source, not PyPi
  doCheck = false;
  pythonImportsCheck = [ "commandparse" ];

  meta = with lib; {
    description = "Python module to parse command based CLI application";
    homepage = "https://github.com/flgy/commandparse";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.fab ];
  };
}
