{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, file, libuv
, raft-canonical, sqlite, lxd }:

stdenv.mkDerivation rec {
  pname = "dqlite";
<<<<<<< HEAD
  version = "1.15.1";
=======
  version = "1.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-GmteQy+nYQFspLvdw44TjuQQeTRQ24OtDeAA+TQJKiU=";
=======
    hash = "sha256-x76f9Sw3BMgWSY7DLIqDjbggp/qVu8mJBtf4znTz9hA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    inherit lxd;
  };

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
