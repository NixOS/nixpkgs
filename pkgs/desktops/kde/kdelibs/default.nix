{ stdenv, fetchurl, xlibs, zlib, perl, qt, openssl, pcre
, pkgconfig, libjpeg, libpng, libtiff, libxml2, libxslt, libtool, expat
, freetype, bzip2, cups, attr, acl
}:

let version = "3.5.9"; in

stdenv.mkDerivation {
  name = "kdelibs-${version}";
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/kdelibs-${version}.tar.bz2";
    md5 = "55e5f00874933d1a7ba7c95e369a205e";
  };

  passthru = {inherit openssl libjpeg qt; inherit (xlibs) libX11;};
  
  buildInputs = [
    zlib perl qt openssl pcre pkgconfig libjpeg libpng libtiff libxml2
    libxslt expat libtool freetype bzip2 cups
    xlibs.libX11 xlibs.libXt xlibs.libXext xlibs.libXrender xlibs.libXft
  ];

  propagatedBuildInputs = [attr acl];

  # Prevent configure from looking for pkg-config and freetype-config
  # in the wrong location (it looks in /usr/bin etc. *before* looking
  # in $PATH).
  preConfigure = ''
    substituteInPlace configure \
      --replace /usr/bin /no-such-path \
      --replace /usr/local/bin /no-such-path \
      --replace /opt/local/bin /no-such-path
  '';

  configureFlags = ''
    --without-arts 
    --with-ssl-dir=${openssl}
    --with-extra-includes=${libjpeg}/include
    --x-includes=${xlibs.libX11}/include
    --x-libraries=${xlibs.libX11}/lib
  '';
}
