{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, pkg-config
, meson
, ninja
, zstd
, curl
, argp-standalone
}:

stdenv.mkDerivation rec {
  pname = "zchunk";
  version = "1.1.8";

  outputs = [ "out" "lib" "dev" ];

  src = fetchFromGitHub {
    owner = "zchunk";
    repo = pname;
    rev = version;
    sha256 = "0q1jafxh5nqgn2w5ciljkh8h46xma0qia8a5rj9m0pxixcacqj6q";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    zstd
    curl
  ] ++ lib.optional stdenv.isDarwin argp-standalone;

  # Darwin needs a patch for argp-standalone usage and differing endian.h location on macOS
  # https://github.com/zchunk/zchunk/pull/35
  patches = [
  (fetchpatch {
    name = "darwin-support.patch";
    url = "https://github.com/zchunk/zchunk/commit/f7db2ac0a95028a7f82ecb89862426bf53a69232.patch";
    sha256 = "0cm84gyii4ly6nsmagk15g9kbfa13rw395nqk3fdcwm0dpixlkh4";
  })
];

  meta = with lib; {
    description = "File format designed for highly efficient deltas while maintaining good compression";
    homepage = "https://github.com/zchunk/zchunk";
    license = licenses.bsd2;
    maintainers = with maintainers; [];
    platforms = platforms.unix;
  };
}
