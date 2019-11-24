{ lib, buildPythonPackage, fetchPypi,
  docopt, pillow
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.8.30";

  meta = {
    description = "Python package for reading Adobe Photoshop PSD files";
    homepage = https://github.com/kmike/psd-tools;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "101d7df09f9a745f7729c25a1621428e501910ed6436d639e1aded4b03c14e02";
  };

  propagatedBuildInputs = [ docopt pillow ];
}
