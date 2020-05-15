{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, file, libco-canonical
, libuv, raft-canonical, sqlite-replication }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "dqlite";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "v${version}";
    sha256 = "04h3wbfv6bkzzmcwaja33x2qkj3czn0p6fgbdgqd1xli8sx2c2k4";
  };

  nativeBuildInputs = [ autoreconfHook file pkgconfig ];
  buildInputs = [
    libco-canonical.dev
    libuv
    raft-canonical.dev
    sqlite-replication
  ];

  # tests hang for ever on x86_64-linux
  doCheck = false;

  outputs = [ "dev" "out" ];

  meta = {
    description = ''
      Expose a SQLite database over the network and replicate it across a
      cluster of peers
    '';
    homepage = "https://github.com/CanonicalLtd/dqlite/";
    license = licenses.asl20;
    maintainers = with maintainers; [ joko wucke13 ];
    platforms = platforms.linux;
  };
}
