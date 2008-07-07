args: with args;

stdenv.mkDerivation {
  name = "tk-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/tcl/tk${version}-src.tar.gz";
    sha256 = "065cbs82a8nklmj4867744skb3l3mqv14s8jwribk2wazzdb0mqp";
  };
  postInstall = ''
    echo -e '#! /bin/sh \n $( readlink -f $( type -tP wish${__substring 0 3 version}) ) "$@"' >$out/bin/wish
    chmod a+x $out/bin/wish
  '';
  configureFlags="--with-tcl=${tcl}/lib";
  preConfigure = "cd unix";

  buildInputs = [tcl x11];
  inherit tcl;
}
