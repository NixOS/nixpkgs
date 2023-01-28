{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, file, libuv
, raft-canonical, sqlite }:

stdenv.mkDerivation rec {
  pname = "dqlite";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-KVQa11gw/8h3Be+52V44W2M+fd7sB35emrS/aUEUGl0=";
  };

  nativeBuildInputs = [ autoreconfHook file pkg-config ];
  buildInputs = [
    libuv
    raft-canonical.dev
    sqlite
  ];

  enableParallelBuilding = true;

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
    maintainers = with maintainers; [ joko adamcstephens ];
    platforms = platforms.linux;
  };
}
