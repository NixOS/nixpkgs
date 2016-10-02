{ stdenv, fetchurl, pkgconfig, libtool, perl, bsdbuild, gettext, mandoc
, libpng, libjpeg, xlibsWrapper, libXinerama, freetype, SDL, mesa
, libsndfile, portaudio, mysql, fontconfig
}:

let srcs = import ./srcs.nix { inherit fetchurl; }; in
stdenv.mkDerivation rec {
  name = "libagar-${version}";
  inherit (srcs) version src;

  preConfigure = ''
    substituteInPlace configure.in \
      --replace '_BSD_SOURCE' '_DEFAULT_SOURCE'
    cat configure.in | ${bsdbuild}/bin/mkconfigure > configure
  '';

  configureFlags = [
    "--with-libtool=${libtool}/bin/libtool"
    "--enable-nls=yes"
    "--with-gettext=${gettext}"
    "--with-jpeg=${libjpeg.dev}"
    "--with-gl=${mesa}"
    "--with-mysql=yes"
    "--with-manpages=yes"
  ];

  outputs = [ "out" "devdoc" ];

  nativeBuildInputs = [ pkgconfig libtool gettext ];
  buildInputs = [
    bsdbuild perl xlibsWrapper libXinerama SDL mesa  mysql.client mandoc
    freetype.dev libpng libjpeg.dev fontconfig portaudio libsndfile
  ];

  meta = with stdenv.lib; {
    description = "Cross-platform GUI toolkit";
    homepage = http://libagar.org/index.html;
    license = with licenses; bsd3;
    maintainers = with maintainers; [ ramkromberg ];
    platforms = with platforms; linux;
  };
}
