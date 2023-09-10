{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, isPyPy
, defusedxml, olefile, freetype, libjpeg, zlib, libtiff, libwebp, libxcrypt, tcl, lcms2, tk, libX11
, libxcb, openjpeg, libimagequant, pyroma, numpy, pytestCheckHook, setuptools
# for passthru.tests
, imageio, matplotlib, pilkit, pydicom, reportlab
}@args:

import ./generic.nix (rec {
  pname = "pillow";
  version = "10.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "Pillow";
    inherit version;
    hash = "sha256-nIK1s+BDx68NlXktDSDM9o9hof7Gs1MOcYtohCJyc5Y=";
  };

  patches = [
    # Pull in zlib-1.3 fix pending upstream inclusion
    #   https://github.com/python-pillow/Pillow/pull/7344
    (fetchpatch {
      name = "zlib-1.3.patch";
      url = "https://github.com/python-pillow/Pillow/commit/9ef7cb39def45b0fe1cdf4828ca20838a1fc39d1.patch";
      hash = "sha256-N7V6Xz+SBHSm3YIgmbty7zbqkv8MzpLMhU4Xxerhx8w=";
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
