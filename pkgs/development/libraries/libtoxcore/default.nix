{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses
, libconfig, pkgconfig }:

let
  version = "18c98eb";
  date = "20131112";
in
stdenv.mkDerivation rec {
  name = "tox-core-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/irungentoo/ProjectTox-Core/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "1g69fz9aspzsrlzlk6fpmjyyhb38v8mmp25nszlbra17n3f209yh";
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
