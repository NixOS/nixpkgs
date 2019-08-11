{ stdenv, fetchurl, pkgconfig, libtool, perl, bsdbuild, gettext, mandoc
, libpng, libjpeg, xlibsWrapper, libXinerama, freetype, SDL, libGLU_combined
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
    "--with-gl=${libGLU_combined}"
    "--with-mysql=${mysql.connector-c}"
    "--with-manpages=yes"
  ];

  outputs = [ "out" "devdoc" ];

  nativeBuildInputs = [ pkgconfig libtool gettext ];

  buildInputs = [
    bsdbuild perl xlibsWrapper libXinerama SDL libGLU_combined mysql.connector-c mandoc
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
