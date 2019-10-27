{ stdenv, fetchurl, gawk }:

let startFPC = import ./binary.nix { inherit stdenv fetchurl; }; in

stdenv.mkDerivation rec {
  version = "3.0.0";
  pname = "fpc";

  src = fetchurl {
    url = "mirror://sourceforge/freepascal/fpcbuild-${version}.tar.gz";
    sha256 = "1v40bjp0kvsi8y0mndqvvhnsqjfssl2w6wpfww51j4rxblfkp4fm";
  };

  buildInputs = [ startFPC gawk ];

  preConfigure =
    if stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux" then ''
      sed -e "s@'/lib/ld-linux[^']*'@'''@" -i fpcsrc/compiler/systems/t_linux.pas
      sed -e "s@'/lib64/ld-linux[^']*'@'''@" -i fpcsrc/compiler/systems/t_linux.pas
    '' else "";

  makeFlags = [ "NOGDB=1" "FPC=${startFPC}/bin/fpc" ];

  installFlags = [ "INSTALL_PREFIX=\${out}" ];

  postInstall = ''
    for i in $out/lib/fpc/*/ppc*; do
      ln -fs $i $out/bin/$(basename $i)
    done
    mkdir -p $out/lib/fpc/etc/
    $out/lib/fpc/*/samplecfg $out/lib/fpc/${version} $out/lib/fpc/etc/
  '';

  passthru = {
    bootstrap = startFPC;
  };

  meta = with stdenv.lib; {
    description = "Free Pascal Compiler from a source distribution";
    homepage = https://www.freepascal.org;
    maintainers = [ maintainers.raskin ];
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.linux;
    inherit version;
  };
}
