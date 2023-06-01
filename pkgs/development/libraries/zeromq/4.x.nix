{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, asciidoc, pkg-config, libsodium
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

  nativeBuildInputs = [ cmake asciidoc pkg-config ];
  buildInputs = [ libsodium ];

  patches = [
    # Fixes a static assertion failure regarding rebinding an allocator on clang 16 and GCC 13.
    (fetchpatch {
      url = "https://github.com/zeromq/libzmq/pull/4480.patch";
      hash = "sha256-tSTYSrQzgnfbY/70QhPdOnpEXX05VAYwVYuW8P1LWf0=";
    })
  ];

  doCheck = false; # fails all the tests (ctest)

  cmakeFlags = lib.optional enableDrafts "-DENABLE_DRAFTS=ON";

  meta = with lib; {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
