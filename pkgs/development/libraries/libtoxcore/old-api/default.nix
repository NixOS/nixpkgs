{ stdenv, fetchFromGitHub, autoreconfHook, libsodium, ncurses, libopus
, libvpx, check, libconfig, pkgconfig }:

let
  version = "4c220e336330213b151a0c20307d0a1fce04ac9e";
  date = "20150126";
in
stdenv.mkDerivation rec {
  name = "tox-core-${date}-${builtins.substring 0 7 version}";

  src = fetchFromGitHub {
    owner  = "irungentoo";
    repo   = "toxcore";
    rev    = version;
    sha256 = "152yamak9ykl8dgkx1qzyrpa3f4xr1s8lgcb5k58r9lb1iwnhvqc";
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

  configureFlags = [
    "--with-libsodium-headers=${libsodium.dev}/include"
    "--with-libsodium-libs=${libsodium.out}/lib"
    "--enable-ntox"
    "--enable-daemon"
  ];

  buildInputs = [
    autoreconfHook libsodium ncurses
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
