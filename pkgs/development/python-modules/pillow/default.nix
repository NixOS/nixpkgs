{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  isPyPy,
  defusedxml,
  olefile,
  freetype,
  libjpeg,
  zlib,
  libtiff,
  libwebp,
  libxcrypt,
  tcl,
  lcms2,
  tk,
  libX11,
  libxcb,
  openjpeg,
  libimagequant,
  numpy,
  pytestCheckHook,
  setuptools,
  # for passthru.tests
  imageio,
  matplotlib,
  pilkit,
  pydicom,
  reportlab,
  sage,
}@args:

import ./generic.nix (
  rec {
    pname = "pillow";
    version = "11.0.0";
    pyproject = true;

    src = fetchPypi {
      pname = "pillow";
      inherit version;
      hash = "sha256-crrLrySsAD/qm/+YN9Hu22CIdY1B4QDBVSkwFR9ndzk=";
    };

    passthru.tests = {
      inherit
        imageio
        matplotlib
        pilkit
        pydicom
        reportlab
        sage
        ;
    };

    meta = {
      homepage = "https://python-pillow.org/";
      description = "Friendly PIL fork (Python Imaging Library)";
      longDescription = ''
        The Python Imaging Library (PIL) adds image processing
        capabilities to your Python interpreter.  This library
        supports many file formats, and provides powerful image
        processing and graphics capabilities.
      '';
      license = lib.licenses.hpnd;
      maintainers = with lib.maintainers; [ prikhi ];
    };
  }
  // args
)
