{ lib, buildPythonPackage, fetchPypi, isPy27
, docopt
, pillow
, enum34
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.8.38";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7fa81ba38388ac1760ae61229681f46a7fc2ed96cb2d435b616873a73e668b64";
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
