{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libtool
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libb2";
  version = "0.98.1";

  src = fetchFromGitHub {
    owner = "BLAKE2";
    repo = "libb2";
    rev = "refs/tags/v${version}";
    sha256 = "0qj8aaqvfcavj1vj5asm4pqm03ap7q8x4c2fy83cqggvky0frgya";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
  ];

  configureFlags = lib.optional stdenv.hostPlatform.isx86 "--enable-fat=yes";

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "The BLAKE2 family of cryptographic hash functions";
    homepage = "https://blake2.net/";
    platforms = platforms.all;
    maintainers = with maintainers; [ dfoxfranke dotlambda ];
    license = licenses.cc0;
  };
}
