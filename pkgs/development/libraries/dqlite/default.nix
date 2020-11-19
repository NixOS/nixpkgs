{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, file, libco-canonical
, libuv, raft-canonical, sqlite-replication }:

stdenv.mkDerivation rec {
  pname = "dqlite";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h7ypigj1b6xbspzc35y89jkp84v8rqiv9qgkyqlqylr7mcw952a";
  };

  nativeBuildInputs = [ autoreconfHook file pkgconfig ];
  buildInputs = [
    libco-canonical.dev
    libuv
    raft-canonical.dev
    sqlite-replication
  ];

  # tests fail
  doCheck = false;

  outputs = [ "dev" "out" ];

  meta = with stdenv.lib; {
    description = ''
      Expose a SQLite database over the network and replicate it across a
      cluster of peers
    '';
    homepage = "https://dqlite.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ joko wucke13 ];
    platforms = platforms.linux;
  };
}
