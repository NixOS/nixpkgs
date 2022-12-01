{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, file, libuv, lz4 }:

stdenv.mkDerivation rec {
  pname = "raft-canonical";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "raft";
    rev = "v${version}";
    sha256 = "050dwy34jh8dihfwfm0r1by2i3sy9crapipp9idw32idm79y4izb";
  };

  nativeBuildInputs = [ autoreconfHook file pkg-config ];
  buildInputs = [ libuv lz4 ];

  enableParallelBuilding = true;

  # Ignore broken test, likely not causing huge breakage
  # (https://github.com/canonical/raft/issues/292)
  postPatch = ''
    substituteInPlace test/integration/test_uv_tcp_connect.c --replace \
      "TEST(tcp_connect, closeDuringHandshake, setUp, tearDownDeps, 0, NULL)" \
      "TEST(tcp_connect, closeDuringHandshake, setUp, tearDownDeps, MUNIT_TEST_OPTION_TODO, NULL)"
  '';

  preConfigure = ''
    substituteInPlace configure --replace /usr/bin/ " "
  '';

  doCheck = true;

  outputs = [ "dev" "out" ];

  meta = with lib; {
    description = ''
      Fully asynchronous C implementation of the Raft consensus protocol
    '';
    longDescription = ''
      The library has modular design: its core part implements only the core
      Raft algorithm logic, in a fully platform independent way. On top of
      that, a pluggable interface defines the I/O implementation for networking
      (send/receive RPC messages) and disk persistence (store log entries and
      snapshots).
    '';
    homepage = "https://github.com/canonical/raft";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wucke13 ];
  };
}
