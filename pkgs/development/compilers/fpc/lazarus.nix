{
stdenv, fetchurl
, fpc
, gtk2, glib, pango, atk, gdk_pixbuf
, libXi, xorgproto, libX11, libXext
, makeWrapper
}:
let
  s =
  rec {
    version = "1.8.4";
    versionSuffix = "";
    url = "mirror://sourceforge/lazarus/Lazarus%20Zip%20_%20GZip/Lazarus%20${version}/lazarus-${version}${versionSuffix}.tar.gz";
    sha256 = "1s8hdip973fc1lynklddl0mvg2jd2lzkfk8hzb8jlchs6jn0362s";
    name = "lazarus-${version}";
  };
  buildInputs = [
    fpc gtk2 glib libXi xorgproto
    libX11 libXext pango atk
    stdenv.cc makeWrapper gdk_pixbuf
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
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
  meta = {
    inherit (s) version;
    license = stdenv.lib.licenses.gpl2Plus ;
    platforms = stdenv.lib.platforms.linux;
    description = "Lazarus graphical IDE for FreePascal language";
    homepage = http://www.lazarus.freepascal.org;
    maintainers = [stdenv.lib.maintainers.raskin];
  };
}
