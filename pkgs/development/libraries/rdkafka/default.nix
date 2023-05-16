{ lib, stdenv, fetchFromGitHub, zlib, zstd, pkg-config, python3, openssl, which }:

stdenv.mkDerivation rec {
  pname = "rdkafka";
<<<<<<< HEAD
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "sha256-v/FjnDg22ZNQHmrUsPvjaCs4UQ/RPAxQdg9i8k6ba/4=";
=======
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "edenhill";
    repo = "librdkafka";
    rev = "v${version}";
    sha256 = "sha256-iEW+n1PSnDoCzQCVfl4T1nchc0kL2q/M3jKNYW2f9/8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config python3 which ];

  buildInputs = [ zlib zstd openssl ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=strict-overflow";

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "librdkafka - Apache Kafka C/C++ client library";
<<<<<<< HEAD
    homepage = "https://github.com/confluentinc/librdkafka";
=======
    homepage = "https://github.com/edenhill/librdkafka";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ commandodev ];
  };
}
