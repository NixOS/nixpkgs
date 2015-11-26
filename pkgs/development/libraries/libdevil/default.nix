{ stdenv, fetchurl, libjpeg, libpng, libmng, lcms1, libtiff, openexr, mesa
, libX11, pkgconfig

, OpenGL
}:

stdenv.mkDerivation rec {

  name ="libdevil-${version}";
  version = "1.7.8";

  src = fetchurl {
    url = "mirror://sourceforge/openil/DevIL-${version}.tar.gz";
    sha256 = "1zd850nn7nvkkhasrv7kn17kzgslr5ry933v6db62s4lr0zzlbv8";
  };

  buildInputs = [ libjpeg libpng libmng lcms1 libtiff openexr mesa libX11 ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ OpenGL ];
  nativeBuildInputs = [ pkgconfig ];

  configureFlags = [ "--enable-ILU" "--enable-ILUT" ];

  preConfigure = ''
    sed -i 's, -std=gnu99,,g' configure
    sed -i 's,malloc.h,stdlib.h,g' src-ILU/ilur/ilur.c
  '';

  postConfigure = ''
    sed -i '/RESTRICT_KEYWORD/d' include/IL/config.h
  '';

  patches =
    [ ( fetchurl {
        url = http://patch-tracker.debian.org/patch/series/dl/devil/1.7.8-6.1/03_CVE-2009-3994.diff;
        sha256 = "0qkx2qfv02igbrmsn6z5a3lbrbwjfh3rb0c2sj54wy0j1f775hbc";
      } )
      ./ftbfs-libpng15.patch
      ./il_endian.h.patch
    ];

  meta = with stdenv.lib; {
    homepage = http://openil.sourceforge.net/;
    description = "An image library which can can load, save, convert, manipulate, filter and display a wide variety of image formats";
    license = licenses.lgpl2;
    platforms = platforms.mesaPlatforms;
    maintainers = [ maintainers.phreedom maintainers.urkud ];
  };
}
