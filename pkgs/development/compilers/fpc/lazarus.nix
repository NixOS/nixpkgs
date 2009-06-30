args : with args; 
rec {
  src = fetchurl {
    url = http://downloads.sourceforge.net/lazarus/lazarus-0.9.26-0.tgz;
    sha256 = "1pb6h35axdmg552pvazgi7jclkx93vssy08cbpa4jw3rij7drhnl";
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

  name = "lazarus-0.9.26-0";
  meta = {
    description = "Lazarus graphical IDE for FreePascal language";
    homepage = http://www.lazarus.freepascal.org ;
  };
}
