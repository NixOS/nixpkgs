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
    sha256 = "1zx1h0ff0wjjkgd0dzjv31i6ag09jw2p9vcssc1iplp60awlpixc";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "ppdeep" ];

  meta = {
    description = "Python library for computing fuzzy hashes (ssdeep)";
    homepage = "https://github.com/elceef/ppdeep";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
