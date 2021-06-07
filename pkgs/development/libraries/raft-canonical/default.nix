{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, file, libuv }:

stdenv.mkDerivation rec {
  pname = "raft-canonical";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "raft";
    rev = "v${version}";
    sha256 = "sha256-Q4m0CCIArgsobhmhqLvkr7fK40SX/qBk6K5Qu0eRLaI=";
  };

  nativeBuildInputs = [ autoreconfHook file pkg-config ];
  buildInputs = [ libuv ];

  enableParallelBuilding = true;

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
    maintainers = with maintainers; [ wucke13 ];
  };
}
