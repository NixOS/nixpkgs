{ stdenv, fetchurl, makeWrapper
, fpc, gtk2, glib, pango, atk, gdk_pixbuf
, libXi, xorgproto, libX11, libXext
}:
stdenv.mkDerivation rec {
  name = "lazarus-${version}";
  version = "1.8.4";

  src = fetchurl {
    url = "mirror://sourceforge/lazarus/Lazarus%20Zip%20_%20GZip/Lazarus%20${version}/lazarus-${version}.tar.gz";
    sha256 = "1s8hdip973fc1lynklddl0mvg2jd2lzkfk8hzb8jlchs6jn0362s";
  };

  buildInputs = [
    fpc gtk2 glib libXi xorgproto
    libX11 libXext pango atk
    stdenv.cc makeWrapper gdk_pixbuf
  ];

  makeFlags = [
    "FPC=fpc"
    "PP=fpc"
    "REQUIRE_PACKAGES+=tachartlazaruspkg"
    "bigide"
  ];

  preBuild = ''
    export makeFlags="$makeFlags LAZARUS_INSTALL_DIR=$out/share/lazarus/ INSTALL_PREFIX=$out/"
    export NIX_LDFLAGS="$NIX_LDFLAGS -L${stdenv.cc.cc.lib}/lib -lXi -lX11 -lglib-2.0 -lgtk-x11-2.0 -lgdk-x11-2.0 -lc -lXext -lpango-1.0 -latk-1.0 -lgdk_pixbuf-2.0 -lcairo -lgcc_s"
    export LCL_PLATFORM=gtk2
    mkdir -p $out/share "$out/lazarus"
    tar xf ${fpc.src} --strip-components=1 -C $out/share -m
    sed -e 's@/usr/fpcsrc@'"$out/share/fpcsrc@" -i ide/include/unix/lazbaseconf.inc
  '';

  postInstall = ''
    wrapProgram $out/bin/startlazarus --prefix NIX_LDFLAGS ' ' "'$NIX_LDFLAGS'" \
      --prefix LCL_PLATFORM ' ' "'$LCL_PLATFORM'"
  '';

  meta = with stdenv.lib; {
    description = "Lazarus graphical IDE for FreePascal language";
    homepage = http://www.lazarus.freepascal.org;
    license = licenses.gpl2Plus ;
    platforms = platforms.linux;
    maintainers = [ maintainers.raskin ];
  };
}
