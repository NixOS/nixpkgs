{ antlr3_4
, bctoolbox
, cmake
, fetchFromGitLab
, libantlr3c
, mbedtls
, stdenv
, zlib
}:

stdenv.mkDerivation rec {
  pname = "belle-sip";
  version = "4.4.13";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "1ad7sqc5y4f3gc8glwmb3rvfzapnvhg981g13x90cg4nzikjvka0";
  };

  nativeBuildInputs = [ cmake antlr3_4 ];

  buildInputs = [ zlib ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=deprecated-declarations"
    "-Wno-error=format-truncation"
    "-Wno-error=cast-function-type"
  ];

  propagatedBuildInputs = [ libantlr3c mbedtls bctoolbox ];

  meta = with stdenv.lib; {
    homepage = "https://linphone.org/technical-corner/belle-sip";
    description = "Modern library implementing SIP (RFC 3261) transport, transaction and dialog layers";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
