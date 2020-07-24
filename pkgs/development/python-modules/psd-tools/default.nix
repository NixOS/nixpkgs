{ lib, buildPythonPackage, fetchPypi, isPy27
, docopt
, pillow
, enum34
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.9.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b1ca602b63b7bcb9f53e9f3d4b815839926533112bc6e3ecf1d37cb125259f3";
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
