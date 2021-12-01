{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "parts";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2212129476f6d285c3aaab309b80b83664d13dca5a42c5ca3500bd32130af7ec";
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
