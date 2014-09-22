{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses, libopus
, libvpx, check, libconfig, pkgconfig }:

let
  version = "f83fcbb13c0";
  date = "20140811";
in
stdenv.mkDerivation rec {
  name = "tox-core-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/irungentoo/toxcore/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "09g74h3qnx9adyxxvzay8m2idbgbln7m4kkm7sg9925mvi5abb1w";
  };

  NIX_LDFLAGS = "-lgcc_s";

  postPatch = ''
    # within Nix chroot builds, localhost is unresolvable
    sed -i -e '/DEFTESTCASE(addr_resolv_localhost)/d' \
      auto_tests/network_test.c
    # takes WAAAY too long (~10 minutes) and would timeout
    sed -i -e '/DEFTESTCASE[^(]*(many_clients\>/d' \
      auto_tests/tox_test.c
  '';

  preConfigure = ''
    autoreconf -i
  '';

  configureFlags = [
    "--with-libsodium-headers=${libsodium}/include"
    "--with-libsodium-libs=${libsodium}/lib"
    "--enable-ntox"
  ];

  buildInputs = [
    autoconf libtool automake libsodium ncurses libopus
    libvpx check libconfig pkgconfig
  ];

  doCheck = false;  # certian tests fail, upstream advice is to wait

  meta = {
    description = "P2P FOSS instant messaging application aimed to replace Skype with crypto";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
