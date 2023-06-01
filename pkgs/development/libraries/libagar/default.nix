{ lib, stdenv, fetchurl, pkg-config, libtool, perl, bsdbuild, gettext, mandoc
, libpng, libjpeg, libXinerama, freetype, SDL, libGLU, libGL
, libsndfile, portaudio, libmysqlclient, fontconfig
}:

let srcs = import ./srcs.nix { inherit fetchurl; }; in
stdenv.mkDerivation {
  pname = "libagar";
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
    "--with-gl=${libGL}"
    "--with-mysql=${libmysqlclient}"
    "--with-manpages=yes"
  ];

  outputs = [ "out" "devdoc" ];

  nativeBuildInputs = [ pkg-config libtool gettext ];

  buildInputs = [
    bsdbuild perl libXinerama SDL libGL libmysqlclient mandoc
    freetype.dev libpng libjpeg.dev fontconfig portaudio libsndfile
  ];

  meta = with lib; {
    description = "Cross-platform GUI toolkit";
    homepage = "http://libagar.org/index.html";
    license = with licenses; bsd3;
    maintainers = with maintainers; [ ramkromberg ];
    platforms = with platforms; linux;
  };
}
