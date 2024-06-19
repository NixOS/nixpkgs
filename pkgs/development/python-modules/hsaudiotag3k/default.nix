{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "hsaudiotag3k";
  version = "1.1.3.post1";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef60e9210d4727e82f0095a686cb07b676d055918f0c59c5bfa8598da03e59d1";
  };

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "A pure Python library that lets one to read metadata from media files";
    homepage = "http://hg.hardcoded.net/hsaudiotag/";
    license = licenses.bsd3;
  };
}
