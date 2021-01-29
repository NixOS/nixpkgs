{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, file, libco-canonical
, libuv, raft-canonical, sqlite-replication }:

stdenv.mkDerivation rec {
  pname = "dqlite";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Savy919boHqR3D3JfKsuZDMRQYJ1Yjfy7oA3w/L+dT4=";
  };

  nativeBuildInputs = [ autoreconfHook file pkg-config ];
  buildInputs = [
    libco-canonical.dev
    libuv
    raft-canonical.dev
    sqlite-replication
  ];

  # tests fail
  doCheck = false;

  outputs = [ "dev" "out" ];

  meta = with lib; {
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
