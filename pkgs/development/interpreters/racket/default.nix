{ stdenv
, fetchurl
, cairo
, coreutils
, file
, libjpeg
, libpng
, libtool
, libXaw
, libXext
, libXft
, libXrender
, libXt
, libXmu
, mesa
, pkgconfig
, which } :

stdenv.mkDerivation rec {
  name = "racket";
  version = "5.0.1";
  pname = "${name}-${version}";

  src = fetchurl {
    url = "http://download.racket-lang.org/installers/${version}/${name}/${pname}-src-unix.tgz";
    sha256 = "18bzzzbxvr888lnpwggismq5grysrwlyg2dp026hhv5n2mk5sfvn";
  };

  buildInputs = [ cairo
                  coreutils
                  file
                  libjpeg
                  libpng
                  libtool
                  libXaw
                  libXext
                  libXft
                  libXrender
                  libXt
                  libXmu
                  mesa
                  pkgconfig
                  which
                ];

  preConfigure = ''
    cd src
    sed -e 's@/usr/bin/uname@'"$(which uname)"'@g' -i configure
    sed -e 's@/usr/bin/file@'"$(which file)"'@g' -i foreign/libffi/configure 
  '';

  configureFlags = [ "--enable-shared" "--enable-lt=${libtool}/bin/libtool" ];

  meta = {
    description = "Racket (formerly called PLT Scheme) is a programming language derived from Scheme.";
    longDescription = ''
      Racket (formerly called PLT Scheme) is a programming language derived
      from Scheme. The Racket project has four primary components: the
      implementation of Racket, a JIT compiler; DrRacket, the Racket program
      development environment; the TeachScheme! outreach, an attempt to turn
      Computing and Programming into "an indispensable part of the liberal
      arts curriculum"; and PLaneT, Racket's web-based package
      distribution system for user-contributed packages.
    '';

    homepage = http://racket-lang.org/;
    license = "LGPL";
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
