{ antlr3_4
, bctoolbox
, cmake
, fetchFromGitLab
, libantlr3c
, mbedtls
, lib, stdenv
, zlib
}:

stdenv.mkDerivation rec {
  pname = "belle-sip";
  version = "4.4.26";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-30w5X/S5VY4zSHs2G4KXOP8mEvC78xakwrcd/Bm1ds4=";
  };

  nativeBuildInputs = [ antlr3_4 cmake ];

  buildInputs = [ zlib ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=deprecated-declarations"
    "-Wno-error=format-truncation"
    "-Wno-error=cast-function-type"
  ];

  propagatedBuildInputs = [ libantlr3c mbedtls bctoolbox ];

  meta = with lib; {
    homepage = "https://linphone.org/technical-corner/belle-sip";
    description = "Modern library implementing SIP (RFC 3261) transport, transaction and dialog layers";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
