{ stdenv, fetchFromGitHub, autoconf, libtool, automake, libsodium, ncurses, libopus
, libvpx, check, libconfig, pkgconfig }:

let
  version = "8760aba257b5f96d082a58abbc9fb4ca2dd73638";
  date = "20150518";
in
stdenv.mkDerivation rec {
  name = "tox-core-${date}-${builtins.substring 0 7 version}";

  src = fetchFromGitHub {
    owner  = "irungentoo";
    repo   = "toxcore";
    rev    = version;
    sha256 = "0kdbxpjs6wy5qwwcn1256sayj0mcyl4gka0y0rhyga5nsma908ak";
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
    "--enable-daemon"
  ];

  buildInputs = [
    autoconf libtool automake libsodium ncurses
    check libconfig pkgconfig
  ] ++ stdenv.lib.optionals (!stdenv.isArm) [
    libopus
  ];

  propagatedBuildInputs = stdenv.lib.optionals (!stdenv.isArm) [ libvpx ];

  # Some tests fail randomly due to timeout. This kind of problem is well known
  # by upstream: https://github.com/irungentoo/toxcore/issues/{950,1054}
  # They don't recommend running tests on 50core machines with other cpu-bound
  # tests running in parallel.
  #
  # NOTE: run the tests locally on your machine before upgrading this package!
  doCheck = false;

  meta = with stdenv.lib; {
    description = "P2P FOSS instant messaging application aimed to replace Skype with crypto";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ viric jgeerds ];
    platforms = platforms.all;
  };
}
