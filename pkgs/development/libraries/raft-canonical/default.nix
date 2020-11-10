{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, file, libuv }:

stdenv.mkDerivation rec {
  pname = "raft-canonical";
  version = "0.9.23";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "raft";
    rev = "v${version}";
    sha256 = "0swn95cf11fqczllmxr0nj3ig532rw4n3w6g3ckdnqka8520xjyr";
  };

  nativeBuildInputs = [ autoreconfHook file pkgconfig ];
  buildInputs = [ libuv ];

  preConfigure = ''
    substituteInPlace configure --replace /usr/bin/ " "
  '';

  doCheck = true;

  outputs = [ "dev" "out" ];

  meta = with stdenv.lib; {
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
