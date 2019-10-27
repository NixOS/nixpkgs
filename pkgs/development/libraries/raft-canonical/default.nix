{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, file, libuv }:

stdenv.mkDerivation rec {
  pname = "raft-canonical";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "raft";
    rev = "v${version}";
    sha256 = "083il7b5kw3pc7m5p9xjpb9dlvfarc51sni92mkgm9ckc32x9vpp";
  };

  nativeBuildInputs = [ autoreconfHook file pkgconfig ];
  buildInputs = [ libuv ];

  preConfigure = ''
    substituteInPlace configure --replace /usr/bin/ " "
  '';

  doCheck = false;
  # Due to
  #io_uv_recv/success/first                                    [ ERROR ]
  #Error: test/lib/dir.c:97: No such file or directory
  #Error: child killed by signal 6 (Aborted)

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
    maintainers = [ maintainers.wucke13 ];
  };
}
