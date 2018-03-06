{ stdenv, buildPythonPackage, fetchPypi, isPyPy
, olefile
, freetype, libjpeg, zlib, libtiff, libwebp, tcl, lcms2, tk, libX11
, pytestrunner
, pytest
}:
buildPythonPackage rec {
  pname = "Pillow";
  version = "5.0.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12f29d6c23424f704c66b5b68c02fe0b571504459605cfe36ab8158359b0e1bb";
  };

  doCheck = !stdenv.isDarwin && !isPyPy;

  # Disable imagefont tests, because they don't work well with infinality:
  # https://github.com/python-pillow/Pillow/issues/1259
  postPatch = ''
    rm Tests/test_imagefont.py
  '';

  propagatedBuildInputs = [ olefile ];

  checkInputs = [ pytest pytestrunner ];

  buildInputs = [
    freetype libjpeg zlib libtiff libwebp tcl lcms2 ]
    ++ stdenv.lib.optionals (isPyPy) [ tk libX11 ];

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
            s|^ZLIB_ROOT =.*$|ZLIB_ROOT = ${libinclude zlib}|g ;
            s|^LCMS_ROOT =.*$|LCMS_ROOT = ${libinclude lcms2}|g ;
            s|^TIFF_ROOT =.*$|TIFF_ROOT = ${libinclude libtiff}|g ;
            s|^TCL_ROOT=.*$|TCL_ROOT = ${libinclude' tcl}|g ;
            s|self\.disable_platform_guessing = None|self.disable_platform_guessing = True|g ;'
    export LDFLAGS="-L${libwebp}/lib"
    export CFLAGS="-I${libwebp}/include"
  ''
  # Remove impurities
  + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py \
      --replace '"/Library/Frameworks",' "" \
      --replace '"/System/Library/Frameworks"' ""
  '';

  meta = with stdenv.lib; {
    homepage = https://python-pillow.github.io/;
    description = "Fork of The Python Imaging Library (PIL)";
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
