{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libb2";
  version = "0.98.1";

  src = fetchFromGitHub {
    owner = "BLAKE2";
    repo = "libb2";
    rev = "v${version}";
    sha256 = "0qj8aaqvfcavj1vj5asm4pqm03ap7q8x4c2fy83cqggvky0frgya";
  };

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  configureFlags = stdenv.lib.optional stdenv.hostPlatform.isx86 "--enable-fat=yes";

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "The BLAKE2 family of cryptographic hash functions";
    homepage = "https://blake2.net/";
    platforms = platforms.all;
    maintainers = with maintainers; [ dfoxfranke dotlambda ];
    license = licenses.cc0;
  };
}
