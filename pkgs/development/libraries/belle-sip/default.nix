{ bctoolbox
, belr
, cmake
, fetchFromGitLab
, lib
, libantlr3c
, mbedtls
, stdenv
, zlib
}:

stdenv.mkDerivation rec {
  pname = "belle-sip";
  version = "linphone-4.4.1";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = "44d5977570280763ee1fecdb920736715bad58a3";
    sha256 = "sha256-w++v3YlDZfpCHAbUQA/RftjRNGkz9J/zYoxZqRgtvnA=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=cast-function-type"
    "-Wno-error=deprecated-declarations"
    "-Wno-error=format-truncation"
    "-Wno-error=stringop-overflow"
  ];

  propagatedBuildInputs = [ libantlr3c mbedtls bctoolbox belr ];

  meta = with lib; {
    homepage = "https://linphone.org/technical-corner/belle-sip";
    description = "Modern library implementing SIP (RFC 3261) transport, transaction and dialog layers. Part of the Linphone project.";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
