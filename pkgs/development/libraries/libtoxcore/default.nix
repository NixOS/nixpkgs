{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses
, libconfig, pkgconfig }:

let
  version = "388b1229b";
  date = "20140220";
in
stdenv.mkDerivation rec {
  name = "tox-core-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/irungentoo/ProjectTox-Core/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "12vggiv0gyv8a2rd5qrv04b7yhfhxb7r0yh75gg5n4jdpcbhvgsd";
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
