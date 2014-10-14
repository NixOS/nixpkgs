{ stdenv, fetchurl, autoconf, libtool, automake, libsodium, ncurses, libopus
, libvpx, check, libconfig, pkgconfig }:

let
  version = "900d72f951";
  date = "20140921";
in
stdenv.mkDerivation rec {
  name = "tox-core-${date}-${version}";

  src = fetchurl {
    url = "https://github.com/irungentoo/toxcore/tarball/${version}";
    name = "${name}.tar.gz";
    sha256 = "1fwgflizb21mp4jwkfac7mgmahlly1f3ldbma6h8h6a2qf3pkn2r";
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
    autoconf libtool automake libsodium ncurses
    check libconfig pkgconfig
  ] ++ stdenv.lib.optionals (!stdenv.isArm) [
    libopus
  ];

  propagatedBuildInputs = stdenv.lib.optionals (!stdenv.isArm) [ libvpx ];

  # Some tests fail in the Sheevaplug due to timeout
  doCheck = !stdenv.isArm;

  meta = {
    description = "P2P FOSS instant messaging application aimed to replace Skype with crypto";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
