{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libuv, sqlite-replication }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "dqlite";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "CanonicalLtd";
    repo = pname;
    rev = "v${version}";
    sha256 = "13l7na5858v2ah1vim6lafmzajgkymfi5rd6bk14cm4vcnxc40wb";
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
