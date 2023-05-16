<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, asciidoc
, pkg-config
, libsodium
, enableDrafts ? false
}:
=======
{ lib, stdenv, fetchFromGitHub, cmake, asciidoc, pkg-config, libsodium
, enableDrafts ? false }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "zeromq";
  version = "4.3.4";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "libzmq";
    rev = "v${version}";
    sha256 = "sha256-epOEyHOswUGVwzz0FLxhow/zISmZHxsIgmpOV8C8bQM=";
  };

<<<<<<< HEAD
  patches = [
    # Backport gcc-13 fix:
    #   https://github.com/zeromq/libzmq/pull/4480
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/zeromq/libzmq/commit/438d5d88392baffa6c2c5e0737d9de19d6686f0d.patch";
      hash = "sha256-tSTYSrQzgnfbY/70QhPdOnpEXX05VAYwVYuW8P1LWf0=";
    })
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ cmake asciidoc pkg-config ];
  buildInputs = [ libsodium ];

  doCheck = false; # fails all the tests (ctest)

  cmakeFlags = lib.optional enableDrafts "-DENABLE_DRAFTS=ON";

  meta = with lib; {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
<<<<<<< HEAD
    license = licenses.lgpl3Plus;
=======
    license = licenses.gpl3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
