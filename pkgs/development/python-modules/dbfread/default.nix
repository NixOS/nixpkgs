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
    sha256 = "07c8a9af06ffad3f6f03e8fe91ad7d2733e31a26d2b72c4dd4cfbae07ee3b73d";
  };

  meta = with lib; {
    description = "Read DBF Files with Python";
    homepage = "https://dbfread.readthedocs.org/";
    license = with licenses; [ mit ];
    maintainers = [ ];
  };
}
