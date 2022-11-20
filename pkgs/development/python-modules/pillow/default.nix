{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, fetchurl
, isPyPy
, defusedxml, olefile, freetype, libjpeg, zlib, libtiff, libwebp, tcl, lcms2, tk, libX11
, libxcb, openjpeg, libimagequant, pyroma, numpy, pytestCheckHook
# for passthru.tests
, imageio, matplotlib, pilkit, pydicom, reportlab
}@args:

import ./generic.nix (rec {
  pname = "pillow";
  version = "9.1.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Pillow";
    inherit version;
    sha256 = "f401ed2bbb155e1ade150ccc63db1a4f6c1909d3d378f7d1235a44e90d75fb97";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-45198.patch";
      url = "https://github.com/python-pillow/Pillow/commit/c9f1b35e981075110a23487a8d4a6cbb59a588ea.patch";
      hash = "sha256-jaITGw3bc+ntcYgt8NG9H4cgDWCqYKFKqkL4SeqRB6w=";
    })
    # this is only the test-case added from the CVE-2022-45199, as
    # a means to "prove" that 9.1.0 isn't vulnerable
    (fetchpatch {
      name = "CVE-2022-45199-test.patch";
      url = "https://github.com/python-pillow/Pillow/commit/2444cddab2f83f28687c7c20871574acbb6dbcf3.patch";
      excludes = [
        "docs/releasenotes/9.3.0.rst"
        # the "fix"
        "src/PIL/TiffImagePlugin.py"
      ];
      hash = "sha256-P63rLbY2AOEXVDcOCUzwHRH8JmgieAIfGgiXPK7P4O0=";
    })
  ];

  # patching mechanism doesn't work with binary files, but the commits contain
  # example images needed for the accompanying tests, so invent our own mechanism
  # to put these in place
  extraPostPatch = lib.concatMapStrings ({commit, sha256, path}: let
      src = fetchurl {
        inherit sha256;
        url = "https://github.com/python-pillow/Pillow/raw/${commit}/${path}";
      };
      dest = path;
    in ''
      cp ${src} ${dest}
    ''
  ) [
    { # needed by CVE-2022-45198.patch
      commit = "c9f1b35e981075110a23487a8d4a6cbb59a588ea";
      sha256 = "sha256-5sijTgmHSsE2P6zwGCHPrtP0lPpZbwtXj66H2sVi7nk=";
      path = "Tests/images/decompression_bomb_extents.gif";
    }
    { # needed by CVE-2022-45199-test.patch
      commit = "2444cddab2f83f28687c7c20871574acbb6dbcf3";
      sha256 = "sha256-yqns5o9ETaNDxqf+oqpK53DQO7KhuuScKJoiDTvew5s=";
      path = "Tests/images/oom-225817ca0f8c663be7ab4b9e717b02c661e66834.tif";
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
    maintainers = with maintainers; [ goibhniu prikhi SuperSandro2000 ];
  };
} // args )
