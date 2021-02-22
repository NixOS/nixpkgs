{ lib, stdenv, buildPythonPackage, fetchPypi, isPyPy, isPy3k
, olefile, freetype, libjpeg, zlib, libtiff, libwebp, tcl, lcms2, tk, libX11
, openjpeg, libimagequant, pyroma, numpy, pytestCheckHook
}@args:

import ./generic.nix (rec {
  pname = "Pillow";
  version = "6.2.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l5rv8jkdrb5q846v60v03mcq64yrhklidjkgwv6s1pda71g17yv";
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
