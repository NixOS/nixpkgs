{ lib, buildPythonPackage, fetchPypi, isPy27
, docopt
, pillow
, enum34
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.9.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d7e510790512f0bb8150c508531c8681c3d9d0ea63b3ba9b11bbf0952cbd69a8";
  };

  propagatedBuildInputs = [
    docopt
    pillow
  ] ++ lib.optionals isPy27 [ enum34 ];

  meta = {
    description = "Python package for reading Adobe Photoshop PSD files";
    homepage = "https://github.com/kmike/psd-tools";
    license = lib.licenses.mit;
    broken = true; # missing packbits from nixpkgs
  };
}
