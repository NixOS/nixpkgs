{ stdenv, fetchurl, gawk }:

let startFPC = import ./binary.nix { inherit stdenv fetchurl; }; in

stdenv.mkDerivation rec {
  version = "2.4.2";
  name = "fpc-${version}";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/sourceforge/freepascal/fpcbuild-${version}.tar.gz";
    sha256 = "291f18a58259a2fc5f36593052f7a950f4872fbbbfb6a19a4e0188b4d5e5efbe";
  };

  buildInputs = [ startFPC gawk ];

  preConfigure =
    if stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" then ''
      sed -e "s@'/lib/ld-linux[^']*'@'''@" -i fpcsrc/compiler/systems/t_linux.pas
      sed -e "s@'/lib64/ld-linux[^']*'@'''@" -i fpcsrc/compiler/systems/t_linux.pas
    '' else "";

  makeFlags = "NOGDB=1";

  installFlags = "INSTALL_PREFIX=\${out}";
  
  postInstall = ''
    for i in $out/lib/fpc/*/ppc*; do
      ln -fs $i $out/bin/$(basename $i)
    done
    mkdir -p $out/lib/fpc/etc/
    $out/lib/fpc/*/samplecfg $out/lib/fpc/${version} $out/lib/fpc/etc/
  '';

  meta = {
    description = "Free Pascal Compiler from a source distribution";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
