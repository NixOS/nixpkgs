{ pname
, version
, disabled
, src
, patches ? []
, meta
, passthru ? {}
, ...
}@args:

with args;

buildPythonPackage rec {
  inherit pname version src meta passthru patches;

  # Disable imagefont tests, because they don't work well with infinality:
  # https://github.com/python-pillow/Pillow/issues/1259
  postPatch = ''
    rm Tests/test_imagefont.py
  '';

  # Disable darwin tests which require executables: `iconutil` and `screencapture`
  disabledTests = lib.optionals stdenv.isDarwin [
    "test_grab"
    "test_grabclipboard"
    "test_save"

    # pillow-simd
    "test_roundtrip"
    "test_basic"
  ] ++ lib.optionals (lib.versions.major version == "6") [
    # RuntimeError: Error setting from dictionary
    "test_custom_metadata"
  ];

  propagatedBuildInputs = [ olefile ]
    ++ lib.optionals (lib.versionAtLeast version "8.2.0") [ defusedxml ];

  checkInputs = [ pytestCheckHook pyroma numpy ];

  buildInputs = [ freetype libjpeg openjpeg libimagequant zlib libtiff libwebp tcl lcms2 ]
    ++ lib.optionals (lib.versionAtLeast version "7.1.0") [ libxcb ]
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
    export LDFLAGS="$LDFLAGS -L${libwebp}/lib"
    export CFLAGS="$CFLAGS -I${libwebp}/include"
  '' + lib.optionalString (lib.versionAtLeast version "7.1.0") ''
    export LDFLAGS="$LDFLAGS -L${libxcb}/lib"
    export CFLAGS="$CFLAGS -I${libxcb.dev}/include"
  '' + lib.optionalString stdenv.isDarwin ''
    # Remove impurities
    substituteInPlace setup.py \
      --replace '"/Library/Frameworks",' "" \
      --replace '"/System/Library/Frameworks"' ""
  '';
}
