args : with args; 
rec {
  version = "0.9.26.2-0";
  src = fetchurl {
    url = "mirror://sourceforge/lazarus/Lazarus%20Zip%20_%20GZip/Lazarus%200.9.28.2/lazarus-0.9.28.2-src.tar.bz2";
    sha256 = "1zad1sylgvhpb210zxypdyng72fpjz1zdf3cpqj9dl94cwn3f4ap";
  };

  buildInputs = [fpc gtk glib libXi inputproto 
    libX11 xproto libXext xextproto pango atk
    stdenv.gcc makeWrapper];
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
    export NIX_LDFLAGS='-lXi -lX11 -lglib-2.0 -lgtk-x11-2.0 -lgdk-x11-2.0 -lc -lXext -lpango-1.0 -latk-1.0'
    export LCL_PLATFORM=gtk2
    ensureDir $out/share
    tar xf ${fpc.src} --strip-components=1 -C $out/share
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
