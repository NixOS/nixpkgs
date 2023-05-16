{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, autoreconfHook
, pkg-config
, protobuf
, zlib
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "protobuf-c";
<<<<<<< HEAD
  version = "unstable-2023-07-08";
=======
  version = "1.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
<<<<<<< HEAD
    rev = "fa86fddbd000316772d1deb5a8d1201fa7599ef7";
    hash = "sha256-pmqZYFREPgSrWPekymTglhtAv6gQR1gP3dOl3hqjYig=";
  };

=======
    rev = "refs/tags/v${version}";
    hash = "sha256-TJCLzxozuZ8ynrBQ2lKyk03N+QA/lbOwywUjDUdTlbM=";
  };

  patches = [
    # https://github.com/protobuf-c/protobuf-c/pull/534
    (fetchpatch {
      url = "https://github.com/protobuf-c/protobuf-c/commit/a6c9ea5207aeac61c57b446ddf5a6b68308881d8.patch";
      hash = "sha256-wTb8+YbvrCrOVpgthI5SJdG/CpQcOzCX4Bv47FPY804=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ protobuf zlib ];

<<<<<<< HEAD
  env.PROTOC = lib.getExe buildPackages.protobuf;
=======
  PROTOC = lib.getExe buildPackages.protobuf;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/protobuf-c/protobuf-c/";
    description = "C bindings for Google's Protocol Buffers";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ nickcao ];
  };
}
