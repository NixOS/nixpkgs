{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, isPyPy
, defusedxml, olefile, freetype, libjpeg, zlib, libtiff, libwebp, libxcrypt, tcl, lcms2, tk, libX11
, libxcb, openjpeg, libimagequant, pyroma, numpy, pytestCheckHook
# for passthru.tests
, imageio, matplotlib, pilkit, pydicom, reportlab
}@args:

import ./generic.nix (rec {
  pname = "pillow";
  version = "9.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Pillow";
    inherit version;
    hash = "sha256-v1SEedM2cm16Ds6252fhefveN4M65CeUYCYxoHDWMPE=";
  };

  patches = [
    (fetchpatch {
      # Fixed type handling for include and lib directories; Remove with 10.0.0
      url = "https://github.com/python-pillow/Pillow/commit/0ec0a89ead648793812e11739e2a5d70738c6be5.patch";
      hash = "sha256-m5R5fLflnbJXbRxFlTjT2X3nKdC05tippMoJUDsJmy0=";
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
    maintainers = with maintainers; [ goibhniu prikhi ];
  };
} // args )
