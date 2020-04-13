{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, file, libuv }:

stdenv.mkDerivation rec {
  pname = "raft-canonical";
  version = "0.9.17";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "raft";
    rev = "v${version}";
    sha256 = "0q444wd6wz85g4zjkdsrf8z7chkjq9rxzq8l6fh37mgf7c23hv09";
  };

  nativeBuildInputs = [ autoreconfHook file pkgconfig ];
  buildInputs = [ libuv ];

  preConfigure = ''
    substituteInPlace configure --replace /usr/bin/ " "
  '';

  # test fails
  #
  #append/finalizeSegment                                      [ ERROR ]
  #Error: test/integration/test_uv_append.c:264: assertion failed: test_dir_has_file(f->dir, "0000000000000001-0000000000000004") is not true
  #Error: child killed by signal 6 (Aborted)

  doCheck = false;

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
