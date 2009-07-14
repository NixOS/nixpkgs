args : with args; 
rec {
  version = "0.9.26.2-0";
  src = fetchurl {
    url = "http://downloads.sourceforge.net/lazarus/lazarus-${version}.tgz";
    sha256 = "5b582685c0447034580fe17c60b8fc84a8b097b6f31ff9b4583cf0eb741297cc";
  };

  buildInputs = [fpc gtk glib libXi inputproto 
    libX11 xproto libXext xextproto gdkpixbuf 
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
    export NIX_LDFLAGS='-lXi -lX11 -lglib -lgtk -lgdk -lgdk_pixbuf -lc -lXext'
    ensureDir $out/share
    tar xf ${fpc.src} --strip-components=1 -C $out/share
    sed -e 's@/usr/fpcsrc@'"$out/share/fpcsrc@" -i ide/include/unix/lazbaseconf.inc
  '') 
  ["minInit" "defEnsureDir" "doUnpack"];

  postInstall = fullDepEntry (''
    wrapProgram $out/bin/startlazarus --prefix NIX_LDFLAGS ' ' "'$NIX_LDFLAGS'"
  '') ["doMakeInstall" "minInit" "defEnsureDir"];

  name = "lazarus-${version}";
  meta = {
    description = "Lazarus graphical IDE for FreePascal language";
    homepage = http://www.lazarus.freepascal.org ;
  };
}
