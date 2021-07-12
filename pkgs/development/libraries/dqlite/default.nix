{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, file, libuv
, raft-canonical, sqlite-replication }:

stdenv.mkDerivation rec {
  pname = "dqlite";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lCMTmKnDv/fb5fP/Ch8AwpuNfmR+gecxeIweO6hHj5U=";
  };

  nativeBuildInputs = [ autoreconfHook file pkg-config ];
  buildInputs = [
    libuv
    raft-canonical.dev
    sqlite-replication
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
    maintainers = with maintainers; [ joko wucke13 ];
    platforms = platforms.linux;
  };
}
