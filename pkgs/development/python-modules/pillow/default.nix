{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, isPyPy
, fetchpatch
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

  # Reverts 04cf5e2cfc5dc1676efd9f5c8d605ddfccb0f9ee, which prevents pillow from
  # finding zlib. This has been fixed upstream, so this patch can be removed on
  # next pillow update.
  patches = [
    (fetchpatch {
      name = "revert-multiple-paths-in-pkgconfig1.patch";
      url = "https://github.com/python-pillow/pillow/commit/17a0a2ee3eeb9df6e9fcf894d204911c7e6e4eef.patch";
      sha256 = "sha256-wAJfCYhBmXaVcVMwNBTk7kCpuJucAmetJTWtL155Ybc=";
      revert = true;
    })
    (fetchpatch {
      name = "revert-multiple-paths-in-pkgconfig2.patch";
      url = "https://github.com/python-pillow/pillow/commit/a0492f796876c2a9b8ba445d72c771b84eff93a5.patch";
      sha256 = "sha256-vCBRczrl9v5QWrYkt85Nb06+ZXKt9GxTxg3djn4/m2o=";
      revert = true;
    })
    (fetchpatch {
      name = "revert-multiple-paths-in-pkgconfig3.patch";
      url = "https://github.com/python-pillow/pillow/commit/04cf5e2cfc5dc1676efd9f5c8d605ddfccb0f9ee.patch";
      sha256 = "sha256-7uvNEUk6fBCBkwcqg6njhsAJGla11diz8KY966zsxew";
      revert = true;
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
