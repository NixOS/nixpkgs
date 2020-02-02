{ lib, buildPythonPackage, fetchPypi, isPy27
, docopt
, pillow
, enum34
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.8.35";

  src = fetchPypi {
    inherit pname version;
    sha256 = "379211cf98ebafbe129088a5c92f575e1ccd7987c40bad9520c209e51008df00";
  };

  propagatedBuildInputs = [
    docopt
    pillow
  ] ++ lib.optionals isPy27 [ enum34 ];

  meta = {
    description = "Python package for reading Adobe Photoshop PSD files";
    homepage = https://github.com/kmike/psd-tools;
    license = lib.licenses.mit;
    broken = true; # missing packbits from nixpkgs
  };
}
