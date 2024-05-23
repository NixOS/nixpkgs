{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "lazy";
  version = "1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c6d27a5ab130fb85435320651a47403adcb37ecbcc501b0c6606391f65f5b43";
    extension = "zip";
  };

  meta = {
    description = "Lazy attributes for Python objects";
    license = lib.licenses.bsd2;
    homepage = "https://github.com/stefanholek/lazy";
  };
}
