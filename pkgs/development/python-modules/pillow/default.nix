{ lib, stdenv, buildPythonPackage, fetchPypi, isPyPy
, olefile
, freetype, libjpeg, zlib, libtiff, libwebp, tcl, lcms2, tk, libX11
, openjpeg, libimagequant
, pyroma, numpy, pytestCheckHook
, isPy3k
}:

buildPythonPackage rec {
  pname = "Pillow";
  version = "8.0.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "11c5c6e9b02c9dac08af04f093eb5a2f84857df70a7d4a6a6ad461aca803fb9e";
  };

  # Disable imagefont tests, because they don't work well with infinality:
  # https://github.com/python-pillow/Pillow/issues/1259
  postPatch = ''
    rm Tests/test_imagefont.py
  '';

  # Disable darwin tests which require executables: `iconutil` and `screencapture`
  disabledTests = lib.optionals stdenv.isDarwin [ "test_save" "test_grab" "test_grabclipboard" ];

  propagatedBuildInputs = [ olefile ];

  checkInputs = [ pytestCheckHook pyroma numpy ];

  buildInputs = [
    freetype libjpeg openjpeg libimagequant zlib libtiff libwebp tcl lcms2 ]
    ++ lib.optionals (isPyPy) [ tk libX11 ];

  # NOTE: we use LCMS_ROOT as WEBP root since there is not other setting for webp.
  # NOTE: The Pillow install script will, by default, add paths like /usr/lib
  # and /usr/include to the search paths. This can break things when building
  # on a non-NixOS system that has some libraries installed that are not
  # installed in Nix (for example, Arch Linux has jpeg2000 but Nix doesn't
  # build Pillow with this support). We patch the `disable_platform_guessing`
  # setting here, instead of passing the `--disable-platform-guessing`
  # command-line option, since the command-line option doesn't work when we run
  # tests.
  preConfigure = let
    libinclude' = pkg: ''"${pkg.out}/lib", "${pkg.out}/include"'';
    libinclude = pkg: ''"${pkg.out}/lib", "${pkg.dev}/include"'';
  in ''
    sed -i "setup.py" \
        -e 's|^FREETYPE_ROOT =.*$|FREETYPE_ROOT = ${libinclude freetype}|g ;
            s|^JPEG_ROOT =.*$|JPEG_ROOT = ${libinclude libjpeg}|g ;
            s|^JPEG2K_ROOT =.*$|JPEG2K_ROOT = ${libinclude openjpeg}|g ;
            s|^IMAGEQUANT_ROOT =.*$|IMAGEQUANT_ROOT = ${libinclude' libimagequant}|g ;
            s|^ZLIB_ROOT =.*$|ZLIB_ROOT = ${libinclude zlib}|g ;
            s|^LCMS_ROOT =.*$|LCMS_ROOT = ${libinclude lcms2}|g ;
            s|^TIFF_ROOT =.*$|TIFF_ROOT = ${libinclude libtiff}|g ;
            s|^TCL_ROOT=.*$|TCL_ROOT = ${libinclude' tcl}|g ;
            s|self\.disable_platform_guessing = None|self.disable_platform_guessing = True|g ;'
    export LDFLAGS="-L${libwebp}/lib"
    export CFLAGS="-I${libwebp}/include"
  ''
  # Remove impurities
  + lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py \
      --replace '"/Library/Frameworks",' "" \
      --replace '"/System/Library/Frameworks"' ""
  '';

  meta = with lib; {
    homepage = "https://python-pillow.org/";
    description = "The friendly PIL fork (Python Imaging Library)";
    longDescription = ''
      The Python Imaging Library (PIL) adds image processing
      capabilities to your Python interpreter.  This library
      supports many file formats, and provides powerful image
      processing and graphics capabilities.
    '';
    license = "http://www.pythonware.com/products/pil/license.htm";
    maintainers = with maintainers; [ goibhniu prikhi ];
  };
}
