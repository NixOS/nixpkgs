{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses
, libconfig, pkgconfig }:

let
  version = "e1158be5a6";
  date = "20140728";
in
stdenv.mkDerivation rec {
  name = "tox-core-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/irungentoo/toxcore/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "1rsh1pbwvngsx5slmd6608b1zqs3jvq70bjr9zyziap9vxka3z1v";
  };

  preConfigure = ''
    autoreconf -i
  '';

  configureFlags = [
    "--with-libsodium-headers=${libsodium}/include"
    "--with-libsodium-libs=${libsodium}/lib"
    "--enable-ntox"
  ];

  buildInputs = [
    autoconf libtool automake libsodium ncurses libconfig pkgconfig
  ];

  doCheck = true;

  meta = {
    description = "P2P FOSS instant messaging application aimed to replace Skype with crypto";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
