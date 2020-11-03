{ lib, buildPythonPackage, fetchPypi, isPy27
, docopt
, pillow
, enum34
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.9.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dece6327b5aa03b53163c63e2bf90b4a7b0ff6872ef743adab140a59cb2318ff";
  };

  requiredPythonModules = [
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
