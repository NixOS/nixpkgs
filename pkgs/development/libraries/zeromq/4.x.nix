{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, asciidoc, pkg-config, libsodium
, enableOpenPGM ? true, openpgm
, enableDrafts ? false }:

stdenv.mkDerivation rec {
  pname = "zeromq";
  version = "4.3.4";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "libzmq";
    rev = "v${version}";
    sha256 = "sha256-epOEyHOswUGVwzz0FLxhow/zISmZHxsIgmpOV8C8bQM=";
  };

  patches =
    # There is a bug in the CMakeLists.txt file where it doesn't
    # correctly link to OpenPGM even if enabled:
    # https://github.com/zeromq/libzmq/pull/4546
    #
    # This patch will likely need to be removed next time the zeromq version
    # is bumped.
    lib.optional enableOpenPGM
      (fetchpatch {
        url = "https://github.com/zeromq/libzmq/commit/5381be6c71f2a34fea40a29c12e3f6f8dcf3bad2.patch";
        hash = "sha256-Wnmu0tlV3nWsnYWuXn6RtzVLNeHHTutnlPKGmZqV+oc=";
      });

  nativeBuildInputs = [ cmake asciidoc pkg-config ];
  buildInputs =
    [ libsodium ] ++
    lib.optional enableOpenPGM openpgm;

  doCheck = false; # fails all the tests (ctest)

  cmakeFlags =
    lib.optional enableDrafts "-DENABLE_DRAFTS=ON" ++
    lib.optional enableOpenPGM "-DWITH_OPENPGM=ON";

  preConfigure =
    # zeromq-4.3.4 is setup to compile against openpgm-5.2, but openpgm-5.3 is
    # currently in Nixpkgs.  This line lists the restriction on 5.3 in the
    # CmakeLists.txt file.
    #
    # This can likely be removed on the next zeromq version bump.
    lib.optionalString enableOpenPGM ''
      substituteInPlace CMakeLists.txt --replace 'openpgm-5.2' 'openpgm-5.3'
    '';

  meta = with lib; {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
