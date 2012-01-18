args : with args; 
rec {
  version = "0.9.30";
  src = fetchurl {
    url = "mirror://sourceforge/lazarus/Lazarus%20Zip%20_%20GZip/Lazarus%20${version}/lazarus-${version}-src.tar.bz2";
    sha256 = "ee8ba358e996a6f436f70d15e64976789c2b8f28b2e2dbf1b737de593b4d23e3";
  };

  buildInputs = [fpc gtk glib libXi inputproto 
    libX11 xproto libXext xextproto pango atk
    stdenv.gcc makeWrapper gdk_pixbuf];
  configureFlags = [];
  makeFlags = [
    "LAZARUS_INSTALL_DIR=$out/lazarus/"
    "INSTALL_PREFIX=$out/"
    "FPC=fpc"
    "PP=fpc"
  ];

  /* doConfigure should be specified separately */
  phaseNames = ["preBuild" "doMakeInstall" "postInstall"];

  preBuild = fullDepEntry (''
    export NIX_LDFLAGS='-lXi -lX11 -lglib-2.0 -lgtk-x11-2.0 -lgdk-x11-2.0 -lc -lXext -lpango-1.0 -latk-1.0 -lgdk_pixbuf-2.0 -lcairo'
    export LCL_PLATFORM=gtk2
    mkdir -p $out/share
    tar xf ${fpc.src} --strip-components=1 -C $out/share -m
    sed -e 's@/usr/fpcsrc@'"$out/share/fpcsrc@" -i ide/include/unix/lazbaseconf.inc
  '') 
  ["minInit" "defEnsureDir" "doUnpack"];

  postInstall = fullDepEntry (''
    wrapProgram $out/bin/startlazarus --prefix NIX_LDFLAGS ' ' "'$NIX_LDFLAGS'" \
    	--prefix LCL_PLATFORM ' ' "'$LCL_PLATFORM'"
  '') ["doMakeInstall" "minInit" "defEnsureDir"];

  name = "lazarus-${version}";
  meta = {
    description = "Lazarus graphical IDE for FreePascal language";
    homepage = http://www.lazarus.freepascal.org ;
    maintainers = [args.lib.maintainers.raskin];
    platforms = args.lib.platforms.linux;
  };
}
