{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, file, libuv
, raft-canonical, sqlite, lxd-lts }:

stdenv.mkDerivation rec {
  pname = "dqlite";
  version = "1.16.7";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-XQvJO4sFKRKDVdtoXP2Ue80otDC0Ry6EB1Z0shetuhw=";
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

  passthru.tests = {
    inherit lxd-lts;
  };

  meta = with lib; {
    description = ''
      Expose a SQLite database over the network and replicate it across a
      cluster of peers
    '';
    homepage = "https://dqlite.io/";
    license = licenses.asl20;
    maintainers = teams.lxc.members;
    platforms = platforms.linux;
  };
}
