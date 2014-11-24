{ stdenv, fetchurl, cairo, file, fontconfig, glib, gtk, freefont_ttf
, libjpeg, libpng, libtool, makeWrapper, openssl, pango, sqlite, which, readline } :

stdenv.mkDerivation rec {
  pname = "racket";
  version = "6.1.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://mirror.racket-lang.org/installers/${version}/${name}-src.tgz";
    sha256 = "090269522d20e7a5ce85d2251a126745746ebf5e87554c05efe03f3b7173da75";
  };

  # Various Racket executables do runtime searches for these.
  ffiSharedLibs = "${cairo}/lib:${fontconfig}/lib:${glib}/lib:${gtk}/lib:${libjpeg}/lib:"
                + "${libpng}/lib:${openssl}/lib:${pango}/lib:${sqlite}/lib:"
                + "${readline}/lib";

  buildInputs = [ file fontconfig freefont_ttf libtool makeWrapper sqlite which ];

  preConfigure = ''
    export LD_LIBRARY_PATH=${ffiSharedLibs}:$LD_LIBRARY_PATH

    # Chroot builds do not have access to /etc/fonts/fonts.conf,
    # but the Racket bootstrap needs a working fontconfig,
    # so here a simple temporary stand-in is used.
    mkdir chroot-fontconfig
    cat ${fontconfig}/etc/fonts/fonts.conf > chroot-fontconfig/fonts.conf
    sed -e 's@</fontconfig>@@' -i chroot-fontconfig/fonts.conf
    echo "<dir>${freefont_ttf}</dir>" >> chroot-fontconfig/fonts.conf
    echo "</fontconfig>" >> chroot-fontconfig/fonts.conf

    # remove extraneous directories from temporary fonts.conf
    sed -e 's@<dir></dir>@@g' \
        -e 's@<dir prefix="xdg">fonts</dir>@@g' \
        -e 's@<dir>~/.fonts</dir>@@g' \
        -e 's@<cachedir prefix="xdg">fontconfig</cachedir>@@g' \
        -e 's@<cachedir>~/.fontconfig</cachedir>@@g' \
        -i chroot-fontconfig/fonts.conf

    export FONTCONFIG_FILE=$(pwd)/chroot-fontconfig/fonts.conf

    cd src
    sed -e 's@/usr/bin/uname@'"$(which uname)"'@g' -i configure
    sed -e 's@/usr/bin/file@'"$(which file)"'@g' -i foreign/libffi/configure
  '';

  configureFlags = [ "--enable-shared" "--enable-lt=${libtool}/bin/libtool" ];

  NIX_LDFLAGS = "-lgcc_s";

  postInstall = ''
    for p in $(ls $out/bin/) ; do
      wrapProgram $out/bin/$p --prefix LD_LIBRARY_PATH ":" "${ffiSharedLibs}";
    done
  '';

  meta = {
    description = "A programmable programming language";
    longDescription = ''
      Racket is a full-spectrum programming language. It goes beyond
      Lisp and Scheme with dialects that support objects, types,
      laziness, and more. Racket enables programmers to link
      components written in different dialects, and it empowers
      programmers to create new, project-specific dialects. Racket's
      libraries support applications from web servers and databases to
      GUIs and charts.
    '';

    homepage = http://racket-lang.org/;
    license = stdenv.lib.licenses.lgpl3;
    maintainers = with stdenv.lib.maintainers; [ kkallio henrytill ];
    platforms = stdenv.lib.platforms.linux;
  };
}
