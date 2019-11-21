# This derivation provides a drop-in replacement for the "yosys"
# package with a wrapper to setup the runtime GUI dependencies for the
# "show" command.
{ stdenv, yosys, runCommand, makeWrapper,
  graphviz, psmisc, python3Packages, hicolor-icon-theme, gnome3 }:

# Runtime dependencies for the "show" command.
let guiPackages = [ graphviz psmisc python3Packages.xdot ]; in

runCommand yosys.pname
  { inherit yosys;
    version = yosys.version;
    meta = yosys.meta;
    buildInputs = [ makeWrapper ];
  }
  ''
  cp -a $yosys $out
  chmod +w $out/bin
  wrapProgram $out/bin/yosys \
    --prefix PATH ':' ${stdenv.lib.makeBinPath guiPackages} \
    --prefix XDG_DATA_DIRS ':' \
      "${hicolor-icon-theme}/share:${gnome3.adwaita-icon-theme}/share"
''
