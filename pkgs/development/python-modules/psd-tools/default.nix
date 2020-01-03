{ lib, buildPythonPackage, fetchPypi,
  docopt, pillow
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.8.32";

  meta = {
    description = "Python package for reading Adobe Photoshop PSD files";
    homepage = https://github.com/kmike/psd-tools;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "fff16658c9ca6bc586adbe0ab060a7d0b7d057eb2a600c3b2001c0558873fb94";
  };

  propagatedBuildInputs = [ docopt pillow ];
}
