{ stdenv, fetchFromGitHub, cmake, asciidoc, pkg-config, libsodium
, enableDrafts ? false }:

stdenv.mkDerivation rec {
  pname = "zeromq";
  version = "4.3.3";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "libzmq";
    rev = "v${version}";
    sha256 = "155kb0ih0xj4jvd39bq8d04bgvhy9143r3632ks1m04455z4qdzd";
  };

  nativeBuildInputs = [ cmake asciidoc pkg-config ];
  buildInputs = [ libsodium ];

  enableParallelBuilding = true;

  doCheck = false; # fails all the tests (ctest)

  cmakeFlags = stdenv.lib.optional enableDrafts "-DENABLE_DRAFTS=ON";

  meta = with stdenv.lib; {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
