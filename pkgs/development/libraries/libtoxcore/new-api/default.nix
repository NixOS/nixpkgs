{ stdenv, fetchFromGitHub, autoreconfHook, libsodium, ncurses, libopus
, libvpx, check, libconfig, pkgconfig }:

stdenv.mkDerivation rec {
  name = "tox-core-dev-20160727";

  src = fetchFromGitHub {
    owner  = "irungentoo";
    repo   = "toxcore";
    rev    = "755f084e8720b349026c85afbad58954cb7ff1d4";
    sha256 = "0ap1gvlyihnfivv235dbrgsxsiiz70bhlmlr5gn1027w3h5kqz8w";
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


  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    autoreconfHook libsodium ncurses check libconfig
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
