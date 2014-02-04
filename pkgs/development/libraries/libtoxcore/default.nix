{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses
, libconfig, pkgconfig }:

let
  version = "dbe256cc82";
  date = "20140203";
in
stdenv.mkDerivation rec {
  name = "tox-core-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/irungentoo/ProjectTox-Core/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "0mqbwwqbm15p16ya8nlij23fgbafjdmnc44nm2vh47m8pyb119lc";
  };

  preConfigure = ''
    autoreconf -i
  '';

  configureFlags = [ "--with-libsodium-headers=${libsodium}/include"
    "--with-libsodium-libs=${libsodium}/lib" 
    "--enable-ntox" ];

  buildInputs = [ autoconf libtool automake libsodium ncurses libconfig
    pkgconfig ];

  doCheck = true;

  meta = {
    description = "P2P FOSS instant messaging application aimed to replace Skype with crypto";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
