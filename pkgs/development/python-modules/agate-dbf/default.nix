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

<<<<<<< HEAD
  meta = {
    description = "Adds read support for dbf files to agate";
    homepage = "https://github.com/wireservice/agate-dbf";
    license = with lib.licenses; [ mit ];
=======
  meta = with lib; {
    description = "Adds read support for dbf files to agate";
    homepage = "https://github.com/wireservice/agate-dbf";
    license = with licenses; [ mit ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
