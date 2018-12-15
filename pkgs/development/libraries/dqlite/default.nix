{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libuv, sqlite-replication }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "dqlite-${version}";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "CanonicalLtd";
    repo = "dqlite";
    rev = "v${version}";
    sha256 = "03dikhjppraagyvjx4zbp7f5jfg74jivighxkwrbzrcy0g8pmcvd";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ libuv sqlite-replication ];

  meta = {
    description = "Expose a SQLite database over the network and replicate it across a cluster of peers";
    homepage = https://github.com/CanonicalLtd/dqlite/;
    license = licenses.asl20;
    maintainers = with maintainers; [ joko ];
    platforms = platforms.unix;
  };
}
