{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, isPyPy
, defusedxml, olefile, freetype, libjpeg, zlib, libtiff, libwebp, libxcrypt, tcl, lcms2, tk, libX11
, libxcb, openjpeg, libimagequant, pyroma, numpy, pytestCheckHook
# for passthru.tests
, imageio, matplotlib, pilkit, pydicom, reportlab
}@args:

import ./generic.nix (rec {
  pname = "pillow";
  version = "9.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Pillow";
    inherit version;
    hash = "sha256-ocLXeARI65P7zDeJvzkWqlcg2ULjeUX0BWaAMX8c0j4=";
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
    maintainers = with maintainers; [ goibhniu prikhi SuperSandro2000 ];
  };
} // args )
