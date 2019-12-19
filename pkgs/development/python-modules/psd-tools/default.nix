{ lib, buildPythonPackage, fetchPypi,
  docopt, pillow
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.8.34";

  meta = {
    description = "Python package for reading Adobe Photoshop PSD files";
    homepage = https://github.com/kmike/psd-tools;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "db471c867399f7a9cc31f9e83b1e6734411c44b26dcecaaefe04c1141f606707";
  };

  propagatedBuildInputs = [ docopt pillow ];
}
