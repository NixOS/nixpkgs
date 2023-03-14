{ lib
, stdenv
, fetchFromGitHub
, argp-standalone
, curl
, meson
, ninja
, pkg-config
, zstd
}:

stdenv.mkDerivation rec {
  pname = "zchunk";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "zchunk";
    repo = pname;
    rev = version;
    hash = "sha256-YzCEQuG38lVhCwZznhIyny6Yya8iNuhdqgYBz9OhGOc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    zstd
  ] ++ lib.optional stdenv.isDarwin argp-standalone;

  outputs = [ "out" "lib" "dev" ];

  meta = with lib; {
    homepage = "https://github.com/zchunk/zchunk";
    description = "File format designed for highly efficient deltas while maintaining good compression";
    longDescription = ''
      zchunk is a compressed file format that splits the file into independent
      chunks. This allows you to only download changed chunks when downloading a
      new version of the file, and also makes zchunk files efficient over rsync.

      zchunk files are protected with strong checksums to verify that the file
      you downloaded is, in fact, the file you wanted.
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
