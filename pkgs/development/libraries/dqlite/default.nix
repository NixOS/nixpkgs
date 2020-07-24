{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, file, libco-canonical
, libuv, raft-canonical, sqlite-replication }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "dqlite";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wm7vkapjg8hdjm6bi48hwsf4w4ppgn3r655gqms5ssjxm50m15d";
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
