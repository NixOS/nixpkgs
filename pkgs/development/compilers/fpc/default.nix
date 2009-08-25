args:

if args ? startFPC && args.startFPC != null then

with args;

stdenv.mkDerivation rec {
  version = "2.2.4";
  name = "fpc-${version}";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/sourceforge/freepascal/fpcbuild-${version}.tar.gz";
    sha256 = "1kxljnivww4riqff8vxann7s135cv634ly3i61rfs1wzwc4lz9bp";
  };

  buildInputs = [startFPC gawk];

  preConfigure =
    if system == "i686-linux" || system == "x86_64-linux" then ''
      sed -e "s@'/lib/ld-linux[^']*'@'''@" -i fpcsrc/compiler/systems/t_linux.pas
    '' else "";

  makeFlags = "NOGDB=1";

  installFlags = "INSTALL_PREFIX=\${out}";
  
  postInstall = ''
    ln -fs $out/lib/fpc/*/ppc386 $out/bin
    mkdir -p $out/lib/fpc/etc/
    $out/lib/fpc/*/samplecfg $out/lib/fpc/${version} $out/lib/fpc/etc/
  '';

  meta = {
    description = "Free Pascal Compiler from a source distribution";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}

else (import ./default.nix (args // {startFPC = (import ./binary.nix args);}))
