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
    ./7.2.0-CVE-2021-25289.patch
    (fetchpatch {
      name = "CVE-2021-25290.patch";
      url = "https://github.com/python-pillow/Pillow/commit/86f02f7c70862a0954bfe8133736d352db978eaa.patch";
      sha256 = "0rwwbkqj10p7r2877nx4x3qwrfgrjww8p05wyvvvvfqp1yv63vxh";
    })
    (fetchpatch {
      name = "CVE-2021-25291.patch";
      url = "https://github.com/python-pillow/Pillow/commit/cbdce6c5d054fccaf4af34b47f212355c64ace7a.patch";
      sha256 = "1fr3mgb57j8qyfcl3cxrc18y3g4ry6pgl7n6whi7h1wnk40ggar6";
    })
    (fetchpatch {
      name = "CVE-2021-25292.patch";
      url = "https://github.com/python-pillow/Pillow/commit/3bce145966374dd39ce58a6fc0083f8d1890719c.patch";
      sha256 = "0bsjw2d9d3z6crawqncvjdvsnk37s05km1b7s6qb035jgzgqlxqx";
    })
    (fetchpatch {
      name = "CVE-2021-25293.prerequisite-1.patch";
      url = "https://github.com/python-pillow/Pillow/commit/46b7e86bab79450ec0a2866c6c0c679afb659d17.patch";
      sha256 = "1z0g64pdfzw20zmfwbfkpw327a2la9z8v65dcbqx3yanm08ispy2";
      includes = ["src/libImaging/SgiRleDecode.c"];
    })
    (fetchpatch {
      name = "CVE-2021-25293.prerequisite-2.patch";
      url = "https://github.com/python-pillow/Pillow/commit/1cbb12fb6e44da0d6d6d58254d0d96930d04af5e.patch";
      sha256 = "0nq8ps5g8b4qrhvla5kq38p56cj28fjsyyxap4x0gqk7wcmvkyy9";
    })
    (fetchpatch {
      name = "CVE-2021-25293.patch";
      url = "https://github.com/python-pillow/Pillow/commit/4853e522bddbec66022c0915b9a56255d0188bf9.patch";
      sha256 = "1p74ynanbamf88w4wzf1gm2wd7gy6h3y8qdmijz14f1z4dy8yv9g";
    })
    (fetchpatch {
      name = "CVE-2021-27921.CVE-2021-27922.CVE-2021-27923.patch";
      url = "https://github.com/python-pillow/Pillow/commit/480f6819b592d7f07b9a9a52a7656c10bbe07442.patch";
      sha256 = "0d7797g0lib3szz5w41b7winpdxcnbf35y4fpyklb49f753wl972";
    })
    ./7.2.0-CVE-2021-25287-CVE-2021-25288.patch
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
    { # needed by 7.2.0-CVE-2021-25289.patch
      commit = "3fee28eb9479bf7d59e0fa08068f9cc4a6e2f04c";
      sha256 = "1lb1442x4yf013h4l37qi4p0zlrqb708d0ng69c76rdnzzfqs8yl";
      path = "Tests/images/crash-0e16d3bfb83be87356d026d66919deaefca44dac.tif";
    }
    { # needed by 7.2.0-CVE-2021-25289.patch
      commit = "3fee28eb9479bf7d59e0fa08068f9cc4a6e2f04c";
      sha256 = "1ghxilrr5mash6cbladwrxa9sdqs93z0c3d24ixx0di5qmddhfwv";
      path = "Tests/images/crash-1152ec2d1a1a71395b6f2ce6721c38924d025bf3.tif";
    }
    { # needed by CVE-2021-25290.patch
      commit = "86f02f7c70862a0954bfe8133736d352db978eaa";
      sha256 = "1d1zv60l90sik9niwqb07ww6nhvy14yl6p8cj6ksnmgm7qdf58vd";
      path = "Tests/images/crash-0c7e0e8e11ce787078f00b5b0ca409a167f070e0.tif";
    }
    { # needed by CVE-2021-25290.patch
      commit = "86f02f7c70862a0954bfe8133736d352db978eaa";
      sha256 = "141yp5bwc0r07samc1vgjdv07kshr6hl9raxs47zhfvab0vpbfd4";
      path = "Tests/images/crash-1185209cf7655b5aed8ae5e77784dfdd18ab59e9.tif";
    }
    { # needed by CVE-2021-25290.patch
      commit = "86f02f7c70862a0954bfe8133736d352db978eaa";
      sha256 = "0jnj5phyv3rlbqvlhk2cxkis1l44b45g7jxzf6fgy8xgpdyaxb2m";
      path = "Tests/images/crash-338516dbd2f0e83caddb8ce256c22db3bd6dc40f.tif";
    }
    { # needed by CVE-2021-25290.patch
      commit = "86f02f7c70862a0954bfe8133736d352db978eaa";
      sha256 = "18m6x3y8ps5b6lqf94mwja5fpv22bdljpha2fggx2nsnrlkaxh4a";
      path = "Tests/images/crash-4f085cc12ece8cde18758d42608bed6a2a2cfb1c.tif";
    }
    { # needed by CVE-2021-25290.patch
      commit = "86f02f7c70862a0954bfe8133736d352db978eaa";
      sha256 = "0fi8aqv3rxjvgkvfmqsg7kd0gb9nv7icwc6ng1ydy55da8gwb6f6";
      path = "Tests/images/crash-86214e58da443d2b80820cff9677a38a33dcbbca.tif";
    }
    { # needed by CVE-2021-25290.patch
      commit = "86f02f7c70862a0954bfe8133736d352db978eaa";
      sha256 = "08c5rnqgmkasfqzmf7n1nqdcy5pacsyjpgc3ybysnwnac592kfsj";
      path = "Tests/images/crash-f46f5b2f43c370fe65706c11449f567ecc345e74.tif";
    }
    { # needed by CVE-2021-25291.patch
      commit = "cbdce6c5d054fccaf4af34b47f212355c64ace7a";
      sha256 = "0x4apm0cg03kk88815b233c7yh80pvm8n7ryal793jxd9qw20583";
      path = "Tests/images/crash-63b1dffefc8c075ddc606c0a2f5fdc15ece78863.tif";
    }
    { # needed by CVE-2021-25293.patch
      commit = "4853e522bddbec66022c0915b9a56255d0188bf9";
      sha256 = "1c7dg1nxcgald6yfy651pw0lbv7l17j90rxjahw8h3vrczbwxicc";
      path = "Tests/images/crash-465703f71a0f0094873a3e0e82c9f798161171b8.sgi";
    }
    { # needed by CVE-2021-25293.patch
      commit = "4853e522bddbec66022c0915b9a56255d0188bf9";
      sha256 = "07mdcnq2x7za84ivxxmcxm5532vpk1z78bzq22ks0cv2gkpviflc";
      path = "Tests/images/crash-64834657ee604b8797bf99eac6a194c124a9a8ba.sgi";
    }
    { # needed by CVE-2021-25293.patch
      commit = "4853e522bddbec66022c0915b9a56255d0188bf9";
      sha256 = "1ia32p8zmm83gqc3655rrzzqnq4b0zyfnqgfmf07nw7pvnv2nq39";
      path = "Tests/images/crash-754d9c7ec485ffb76a90eeaab191ef69a2a3a3cd.sgi";
    }
    { # needed by CVE-2021-25293.patch
      commit = "4853e522bddbec66022c0915b9a56255d0188bf9";
      sha256 = "0m5b48cqss0jmnkw54h9jdxakbw3y6bxqgzmcl9wk77anq8czdff";
      path = "Tests/images/crash-abcf1c97b8fe42a6c68f1fb0b978530c98d57ced.sgi";
    }
    { # needed by CVE-2021-25293.patch
      commit = "4853e522bddbec66022c0915b9a56255d0188bf9";
      sha256 = "0k145flxrxay4s5dqvy1avzzs4bdy33c1by9qbgbzcvj7nhpsynm";
      path = "Tests/images/crash-b82e64d4f3f76d7465b6af535283029eda211259.sgi";
    }
    { # needed by CVE-2021-25293.patch
      commit = "4853e522bddbec66022c0915b9a56255d0188bf9";
      sha256 = "0ryv73b2mja4chxaszjlxb9r7h4jxmlc7lqvaxz83fhqisp32wll";
      path = "Tests/images/crash-c1b2595b8b0b92cc5f38b6635e98e3a119ade807.sgi";
    }
    { # needed by CVE-2021-25293.patch
      commit = "4853e522bddbec66022c0915b9a56255d0188bf9";
      sha256 = "0c8qh3qyqw53wvkkkgpbhxcz72rjw2yxm8wb1s78mys78a7d83ai";
      path = "Tests/images/crash-db8bfa78b19721225425530c5946217720d7df4e.sgi";
    }
    { # needed by CVE-2021-27921.CVE-2021-27922.CVE-2021-27923.patch
      commit = "480f6819b592d7f07b9a9a52a7656c10bbe07442";
      sha256 = "1y6317hfvmlcnkbf2qy6a7i8zxgydi9s8lagb21fn2a3k1igymha";
      path = "Tests/images/oom-8ed3316a4109213ca96fb8a256a0bfefdece1461.icns";
    }
    { # needed by 7.2.0-CVE-2021-25287-CVE-2021-25288.patch
      commit = "3bf5eddb89afdf690eceaa52bc4d3546ba9a5f87";
      sha256 = "1rsjr6nsljghs6v0vp671bffpw3sj5b57g23mcd0acj4qsm9rjdy";
      path = "Tests/images/crash-4fb027452e6988530aa5dabee76eecacb3b79f8a.j2k";
    }
    { # needed by 7.2.0-CVE-2021-25287-CVE-2021-25288.patch
      commit = "3bf5eddb89afdf690eceaa52bc4d3546ba9a5f87";
      sha256 = "13immd1h2cwcj9vf1g7v1yrhwnbk50dqz447fzjz4m1zsp17627i";
      path = "Tests/images/crash-7d4c83eb92150fb8f1653a697703ae06ae7c4998.j2k";
    }
    { # needed by 7.2.0-CVE-2021-25287-CVE-2021-25288.patch
      commit = "3bf5eddb89afdf690eceaa52bc4d3546ba9a5f87";
      sha256 = "0xdnaayjj6n9mzpxpprq6508p0w618l2c6y2jgbs36gmj21smpis";
      path = "Tests/images/crash-ccca68ff40171fdae983d924e127a721cab2bd50.j2k";
    }
    { # needed by 7.2.0-CVE-2021-25287-CVE-2021-25288.patch
      commit = "3bf5eddb89afdf690eceaa52bc4d3546ba9a5f87";
      sha256 = "1czlvbdc89bcq48cgf1kay3ncbgag4i1pz555g8cm4dxxirv5j0x";
      path = "Tests/images/crash-d2c93af851d3ab9a19e34503626368b2ecde9c03.j2k";
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
