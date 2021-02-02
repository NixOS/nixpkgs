{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, fetchurl, isPyPy
, olefile
, freetype, libjpeg, zlib, libtiff, libwebp, tcl, lcms2, tk, libX11
, openjpeg, libimagequant
, pyroma, numpy, pytestCheckHook
, isPy3k
}:

buildPythonPackage rec {
  pname = "Pillow";
  version = "7.2.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "97f9e7953a77d5a70f49b9a48da7776dc51e9b738151b22dacf101641594a626";
  };

  patches = [
    ./7.2.0-CVE-2020-35653.patch
    (fetchpatch {
      name = "CVE-2020-35654.prerequisite-1.patch";
      url = "https://github.com/python-pillow/Pillow/commit/21533e4deba80290bbc46f1a9e660196f75be45f.patch";
      sha256 = "19i7svxqlcz02ffcx1n1r6brf4m2iqm3k0zq3wd8k1pj2zw9gkhi";
    })
    (fetchpatch {
      name = "CVE-2020-35654.prerequisite-2.patch";
      url = "https://github.com/python-pillow/Pillow/commit/26bf1c352489c9e847ff770cd752e97fda5b82cb.patch";
      sha256 = "0h4ch8in2ljz3qgah7k8nwzby1kg02p0fbkg8zzvmmkms051v0im";
    })
    (fetchpatch {
      name = "CVE-2020-35654.part-1.patch";
      url = "https://github.com/python-pillow/Pillow/commit/eb8c1206d6b170d4e798a00db7432e023853da5c.patch";
      sha256 = "0cw1hp9irzhgh52s9g5mb6j6cry5gz2n5al4sy1sl5k998h76qaq";
    })
    (fetchpatch {
      name = "CVE-2020-35654.part-2.patch";
      url = "https://github.com/python-pillow/Pillow/commit/45a62e91b1f72e79989a7919af97b062dc8dfaf4.patch";
      sha256 = "1kk4jrbz1h74pa5racxc1skp0rgwb00b8ybfyb7v7wmc34f1lm8f";
    })
    (fetchpatch {
      name = "CVE-2020-35655.part-1.patch";
      url = "https://github.com/python-pillow/Pillow/commit/7e95c63fa7f503f185d3d9eb16b9cee1e54d1e46.patch";
      sha256 = "15zjkiwcmnv70vy1cfwrvzkfjmgclw4fzvina4rjd8xqap9na5fr";
    })
    (fetchpatch {
      name = "CVE-2020-35655.part-2.patch";
      url = "https://github.com/python-pillow/Pillow/commit/9a2c9f722f78773e608d44710873437baf3f17d1.patch";
      sha256 = "15dhzd3i8xwx2iaff2qp6z3h0b2yrzcmqi6x7ngld96805gf7v2q";
    })
  ];

  # patching mechanism doesn't work with binary files, but the commits contain
  # example images needed for the accompanying tests, so invent our own mechanism
  # to put these in place
  injectMissingBinFiles = stdenv.lib.concatMapStrings ({commit, sha256, path}: let
      src = fetchurl {
        inherit sha256;
        url = "https://github.com/python-pillow/Pillow/raw/${commit}/${path}";
      };
      dest = path;
    in ''
      cp ${src} ${dest}
    ''
  ) [
    { # needed by CVE-2020-35653.patch
      commit = "2f409261eb1228e166868f8f0b5da5cda52e55bf";
      sha256 = "1gf7zn0qv0i8qvr22sm9azchwizb9aa4xxipy6x5lh7kgb974g0f";
      path = "Tests/images/ossfuzz-4836216264589312.pcx";
    }
    { # needed by CVE-2020-35654.part-1.patch
      commit = "eb8c1206d6b170d4e798a00db7432e023853da5c";
      sha256 = "0v7jg2xdqzyq3rq6jq0ipsy335sw557symv5jrcz9rdfgkbafh92";
      path = "Tests/images/crash-2020-10-test.tif";
    }
    { # needed by CVE-2020-35655.part-1.patch
      commit = "7e95c63fa7f503f185d3d9eb16b9cee1e54d1e46";
      sha256 = "0jkzwnv11c1h3hy0ri6kqvcjj800armzrvwc9724ivnm2id8qi8z";
      path = "Tests/images/crash-6b7f2244da6d0ae297ee0754a424213444e92778.sgi";
    }
    { # needed by CVE-2020-35655.part-1.patch
      commit = "7e95c63fa7f503f185d3d9eb16b9cee1e54d1e46";
      sha256 = "0is0r49pbaxy8mgp5fdlx9hm7zdp64ij38hzgnjj9pzxxdrcw3qk";
      path = "Tests/images/ossfuzz-5730089102868480.sgi";
    }
  ];

  # Disable imagefont tests, because they don't work well with infinality:
  # https://github.com/python-pillow/Pillow/issues/1259
  postPatch = ''
    rm Tests/test_imagefont.py
  '' + injectMissingBinFiles;

  # Disable darwin tests which require executables: `iconutil` and `screencapture`
  disabledTests = stdenv.lib.optionals stdenv.isDarwin [ "test_save" "test_grab" "test_grabclipboard" ];

  propagatedBuildInputs = [ olefile ];

  checkInputs = [ pytestCheckHook pyroma numpy ];

  buildInputs = [
    freetype libjpeg openjpeg libimagequant zlib libtiff libwebp tcl lcms2 ]
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
  + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py \
      --replace '"/Library/Frameworks",' "" \
      --replace '"/System/Library/Frameworks"' ""
  '';

  meta = with stdenv.lib; {
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
