{
  lib,
  fetchPypi,
  buildPythonPackage,
  agate,
  dbf,
  dbfread,
}:

buildPythonPackage rec {
  pname = "agate-dbf";
  version = "0.2.3";
  format = "setuptools";

  propagatedBuildInputs = [
    agate
    dbf
    dbfread
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mKK1N1cTbMdNwpflniEB009tSPQfdBVrtsDeJruiqj8=";
  };

  meta = with lib; {
    description = "Adds read support for dbf files to agate";
    homepage = "https://github.com/wireservice/agate-dbf";
    license = with licenses; [ mit ];
    maintainers = [ ];
  };
}
