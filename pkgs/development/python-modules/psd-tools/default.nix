{ lib, buildPythonPackage, fetchPypi, isPy27
, docopt
, pillow
, enum34
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.9.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d01e11581442dfcc1bd73ac3278bdf1f98e9df8f083a11e5989632ff97322b65";
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
