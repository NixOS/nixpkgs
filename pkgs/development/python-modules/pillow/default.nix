{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, isPyPy
, defusedxml, olefile, freetype, libjpeg, zlib, libtiff, libwebp, libxcrypt, tcl, lcms2, tk, libX11
, libxcb, openjpeg, libimagequant, numpy, pytestCheckHook, setuptools
# for passthru.tests
, imageio, matplotlib, pilkit, pydicom, reportlab
}@args:

import ./generic.nix (rec {
  pname = "pillow";
  version = "10.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "Pillow";
    inherit version;
    hash = "sha256-5r+N5sNu2WyG6jtuHVJzxT9G71GKBiRkzX713Sz5Ljg=";
  };

  passthru.tests = {
    inherit imageio matplotlib pilkit pydicom reportlab;
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
    maintainers = with maintainers; [ goibhniu prikhi ];
  };
} // args )
