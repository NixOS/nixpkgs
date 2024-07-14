{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "ppdeep";
  version = "20200505";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rMdLuQLm0hsD05rtdAWXCTxlYhhb/gbam1Jy4ByAof8=";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "ppdeep" ];

  meta = with lib; {
    description = "Python library for computing fuzzy hashes (ssdeep)";
    homepage = "https://github.com/elceef/ppdeep";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
