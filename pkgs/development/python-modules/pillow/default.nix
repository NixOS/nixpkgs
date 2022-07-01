{ lib
, stdenv
, fetchpatch
, buildPythonPackage
, pythonOlder
, fetchPypi
, isPyPy
, defusedxml, olefile, freetype, libjpeg, zlib, libtiff, libwebp, tcl, lcms2, tk, libX11
, libxcb, openjpeg, libimagequant, pyroma, numpy, pytestCheckHook
# for passthru.tests
, imageio, matplotlib, pilkit, pydicom, reportlab
}@args:

import ./generic.nix (rec {
  pname = "pillow";
  version = "9.1.1";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Pillow";
    inherit version;
    sha256 = "sha256-dQJTmTm1PXVl89Edh8eOfskA08cpRdTuDi8lDVmDCaA=";
  };

  patches = [
    # Fix failing test with libtiff 4.4.0
    (fetchpatch {
      url = "https://github.com/python-pillow/Pillow/commit/40a918d274182b7d7c063d7797fb77d967982c4a.patch";
      sha256 = "sha256-f8m3Xt3V3pHggK1JEc2tnPmrTVPFjfV4YJqwE1KM1pA=";
    })
  ];

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
