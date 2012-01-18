{ stdenv }:

stdenv.mkDerivation {
  name = "pythonhome-wrapper";

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    echo '
#!/bin/sh

BINDIR=`dirname $0`
PYTHONHOME=`dirname $BINDIR`
PYTHONHOME=`(cd $PYTHONHOME && pwd)`
export PYTHONHOME

$BINDIR/python "$@"
    ' > $out/bin/py
    chmod +x $out/bin/py
  '';
}
