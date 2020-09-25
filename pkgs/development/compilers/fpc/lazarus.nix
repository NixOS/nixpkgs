{ stdenv, fetchurl, makeWrapper
, fpc, gtk2, glib, pango, atk, gdk-pixbuf
, libXi, xorgproto, libX11, libXext
, gdb, gnumake, binutils
}:
stdenv.mkDerivation rec {
  pname = "lazarus";
  version = "2.0.8";

  src = fetchurl {
    url = "mirror://sourceforge/lazarus/Lazarus%20Zip%20_%20GZip/Lazarus%20${version}/lazarus-${version}.tar.gz";
    sha256 = "1iciqydb0miqdrh89aj59gy7kfcwikkycqssq9djcqsw1ql3gc4h";
  };

  buildInputs = [
    fpc gtk2 glib libXi xorgproto
    libX11 libXext pango atk
    stdenv.cc makeWrapper gdk-pixbuf
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
    wrapProgram $out/bin/startlazarus --prefix NIX_LDFLAGS ' ' \
      "$(echo "$NIX_LDFLAGS" | sed -re 's/-rpath [^ ]+//g')" \
      --prefix NIX_LDFLAGS_${binutils.suffixSalt} ' ' \
      "$(echo "$NIX_LDFLAGS" | sed -re 's/-rpath [^ ]+//g')" \
      --prefix LCL_PLATFORM ' ' "$LCL_PLATFORM" \
      --prefix PATH ':' "${fpc}/bin:${gdb}/bin:${gnumake}/bin:${binutils}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Lazarus graphical IDE for FreePascal language";
    homepage = "http://www.lazarus.freepascal.org";
    license = licenses.gpl2Plus ;
    platforms = platforms.linux;
    maintainers = [ maintainers.raskin ];
  };
}
