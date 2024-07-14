{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "dbfread";
  version = "2.0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B8iprwb/rT9vA+j+ka19JzPjGibStyxN1M+64H7jtz0=";
  };

  meta = with lib; {
    description = "Read DBF Files with Python";
    homepage = "https://dbfread.readthedocs.org/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
  };
}
