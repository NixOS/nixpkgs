{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchpatch
, fetchPypi
, fetchurl
, isPyPy
, defusedxml, olefile, freetype, libjpeg, zlib, libtiff, libwebp, libxcrypt, tcl, lcms2, tk, libX11
, libxcb, openjpeg, libimagequant, pyroma, numpy, pytestCheckHook, setuptools
# for passthru.tests
, imageio, matplotlib, pilkit, pydicom, reportlab
}@args:

import ./generic.nix (rec {
  pname = "pillow";
  version = "10.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "pillow";
    inherit version;
    hash = "sha256-6H8LLHgVfhLXaGsn1jwHD9ZdmU6N2ubzKODc9KDNAH4=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2024-28219.patch";
      url = "https://github.com/python-pillow/Pillow/commit/2a93aba5cfcf6e241ab4f9392c13e3b74032c061.patch";
      hash = "sha256-djbVjbWWAAr+QMErT+lFhj2HF7uGn8oI68tC+i1PHys=";
    })
  ];

  # patching mechanism doesn't work with binary files, but the commits contain
  # example images needed for the accompanying tests, so invent our own mechanism
  # to put these in place
  extraPostPatch = lib.concatMapStrings ({commit, hash, path}: let
      src = fetchurl {
        inherit hash;
        url = "https://github.com/python-pillow/Pillow/raw/${commit}/${path}";
      };
      dest = path;
    in ''
      cp ${src} ${dest}
    ''
  ) [
    { # needed by CVE-2024-28219.patch
      commit = "2a93aba5cfcf6e241ab4f9392c13e3b74032c061";
      hash = "sha256-rCgFueB7b6O6dAaqSOhNhwQQl9pmIgzCo4Xhe7KJPME=";
      path = "Tests/icc/sGrey-v2-nano.icc";
    }
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
