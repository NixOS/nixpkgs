{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "parts";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ym238hxwsw15ivvf6gzmkmla08b9hwhdyc3v6rs55wga9j3a4db";
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
