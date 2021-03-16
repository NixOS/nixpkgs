{ lib, stdenv, buildPythonPackage, fetchPypi, isPyPy, isPy3k
, olefile, freetype, libjpeg, zlib, libtiff, libwebp, tcl, lcms2, tk, libX11
, libxcb, openjpeg, libimagequant, pyroma, numpy, pytestCheckHook
}@args:

import ./generic.nix (rec {
  pname = "Pillow";
  version = "8.1.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "086g7nhv52wclrwnzbzs2x3nvyzs2hfq1bvgivsrp5f7r7wiiz7n";
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
