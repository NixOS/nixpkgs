{ lib, stdenv, buildPythonPackage, fetchPypi, isPyPy, isPy3k
, olefile, freetype, libjpeg, zlib, libtiff, libwebp, tcl, lcms2, tk, libX11
, libxcb, openjpeg, libimagequant, pyroma, numpy, pytestCheckHook
}@args:

import ./generic.nix (rec {
  pname = "Pillow";
  version = "8.0.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "11c5c6e9b02c9dac08af04f093eb5a2f84857df70a7d4a6a6ad461aca803fb9e";
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
    license = "http://www.pythonware.com/products/pil/license.htm";
    maintainers = with maintainers; [ goibhniu prikhi SuperSandro2000 ];
  };
} // args )
