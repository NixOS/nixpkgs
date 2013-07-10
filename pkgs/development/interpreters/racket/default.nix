{ stdenv, fetchurl, cairo, file, pango, glib, gtk
, which, libtool, makeWrapper, libjpeg, libpng
, fontconfig, liberation_ttf, sqlite } :

stdenv.mkDerivation rec {
  pname = "racket";
  version = "5.3.5";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://download.racket-lang.org/installers/${version}/${pname}/${name}-src-unix.tgz";
    sha256 = "0xrd25d2iskkih08ydcjqnasg84r7g32apvdw7qzlp4xs1xynjwk";
  };

  # Various racket executables do run-time searches for these.
  ffiSharedLibs = "${glib}/lib:${cairo}/lib:${pango}/lib:${gtk}/lib:${libjpeg}/lib:${libpng}/lib:${sqlite}/lib";

  buildInputs = [ file libtool which makeWrapper fontconfig liberation_ttf sqlite ];

  preConfigure = ''
    export LD_LIBRARY_PATH=${ffiSharedLibs}:$LD_LIBRARY_PATH

    # Chroot builds do not have access to /etc/fonts/fonts.conf, but the Racket bootstrap
    # needs a working fontconfig, so here a simple standin is used.
    mkdir chroot-fontconfig
    cat ${fontconfig}/etc/fonts/fonts.conf > chroot-fontconfig/fonts.conf
    sed -e 's@</fontconfig>@@' -i chroot-fontconfig/fonts.conf
    echo "<dir>${liberation_ttf}</dir>" >> chroot-fontconfig/fonts.conf
    echo "</fontconfig>" >> chroot-fontconfig/fonts.conf
   
    export FONTCONFIG_FILE=$(pwd)/chroot-fontconfig/fonts.conf

    cd src
    sed -e 's@/usr/bin/uname@'"$(which uname)"'@g' -i configure
    sed -e 's@/usr/bin/file@'"$(which file)"'@g' -i foreign/libffi/configure 
  '';

  configureFlags = [ "--enable-shared" "--enable-lt=${libtool}/bin/libtool" ];

  postInstall = ''
    for p in $(ls $out/bin/) ; do
      wrapProgram $out/bin/$p --prefix LD_LIBRARY_PATH ":" "${ffiSharedLibs}" ;
    done
  '';

  meta = {
    description = "A programming language derived from Scheme (formerly called PLT Scheme).";
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
    license = stdenv.lib.licenses.lgpl2Plus; # and licenses of contained libraries
    maintainers = [ stdenv.lib.maintainers.kkallio ];
    platforms = stdenv.lib.platforms.linux;
  };
}
