{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, file, libuv, lz4 }:

stdenv.mkDerivation rec {
  pname = "raft-canonical";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "raft";
    rev = "refs/tags/v${version}";
    hash = "sha256-qDLAEhknY+BB83OC6tfi7w/ZY/K492J5ZglLNUoBwbc=";
  };

  nativeBuildInputs = [ autoreconfHook file pkg-config ];
  buildInputs = [ libuv lz4 ];

  enableParallelBuilding = true;

  patches = [
    # network tests either hang indefinitely, or fail outright
    ./disable-net-tests.patch

    # missing dir check is flaky
    ./disable-missing-dir-test.patch
  ];

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
    maintainers = with maintainers; [ wucke13 adamcstephens ];
  };
}
