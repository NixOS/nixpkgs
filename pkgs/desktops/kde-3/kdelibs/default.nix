{ stdenv, fetchurl, xlibs, zlib, perl, qt3, openssl, pcre
, pkgconfig, libtiff, libxml2, libxslt, libtool, expat
, freetype, bzip2, cups, attr, acl
}:

let version = "3.5.10"; in

stdenv.mkDerivation {
  name = "kdelibs-${version}";
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/kdelibs-${version}.tar.bz2";
    sha256 = "0wjw51r96h6rngbsrzndw890xggzvrakydsbaldlrvbh3jq9qzk1";
  };

  patches = [
    # We're not supposed to use linux/inotify.h, use sys/inotify.h instead.
    # Adapted from Gentoo.
    ./inotify.patch
    
    # Fixes compilation issues with openssl-1.0.0
    ./kdelibs-3.5.10-openssl_1.0.0.patch
  ];

  buildInputs = [
    zlib perl qt3 openssl pcre pkgconfig libtiff libxml2
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
    --x-includes=${xlibs.libX11}/include
    --x-libraries=${xlibs.libX11}/lib
  '';

  meta.platforms = stdenv.lib.platforms.linux;
}
