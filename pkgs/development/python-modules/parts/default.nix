{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "parts";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4137612bc050f606b4d6f9e6a554ebfb50633c8dd9699481f82271f84d9425f";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "parts" ];

  meta = with lib; {
    description = "Python library for common list functions related to partitioning lists";
    homepage = "https://github.com/lapets/parts";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
