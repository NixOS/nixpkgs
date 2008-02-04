args: with args;

stdenv.mkDerivation {
  name = "tk-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/tcl/tk${version}-src.tar.gz";
    sha256 = "0cciavzd05bpm5yfppid0s0vsf8kabwia9620vgvi26sv1gjgwhb";
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
