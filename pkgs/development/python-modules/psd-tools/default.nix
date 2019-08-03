{ lib, buildPythonPackage, fetchPypi,
  docopt, pillow
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.4";

  meta = {
    description = "Python package for reading Adobe Photoshop PSD files";
    homepage = https://github.com/kmike/psd-tools;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g2vss5hwlk96w0yj42n7ia56mly51n92f2rlbrifhn8hfbxd38s";
  };

  propagatedBuildInputs = [ docopt pillow ];
}
