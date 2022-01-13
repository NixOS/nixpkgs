{ lib, stdenv, buildPythonPackage, fetchPypi, isPyPy, isPy3k
, defusedxml, olefile, freetype, libjpeg, zlib, libtiff, libwebp, tcl, lcms2, tk, libX11
, libxcb, openjpeg, libimagequant, pyroma, numpy, pytestCheckHook
}@args:

import ./generic.nix (rec {
  pname = "Pillow";
  version = "9.0.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gjry0yqryd2678sm47jhdnbghzxn5wk8pgyaqwr4qi7x5ijjvpf";
  };

  meta = with lib; {
    homepage = "https://python-pillow.org/";
    description = "The friendly PIL fork (Python Imaging Library)";
    longDescription = ''
      The Python Imaging Library (PIL) adds image processing
      capabilities to your Python interpreter.  This library
      supports many file formats, and provides powerful image
      processing and graphics capabilities.
    '';
    license = licenses.hpnd;
    maintainers = with maintainers; [ goibhniu prikhi SuperSandro2000 ];
  };
} // args )
