{ bctoolbox
, belr
, cmake
, fetchFromGitLab
, lib
, libantlr3c
, mbedtls_2
, stdenv
, zlib
}:

stdenv.mkDerivation rec {
  pname = "belle-sip";
  version = "5.2.16";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-LMbQz22ENTT27jr9tGakzNjidC5nfCuLDMZ6sFwtRKI=";
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

  propagatedBuildInputs = [ libantlr3c mbedtls_2 bctoolbox belr ];

  meta = with lib; {
    homepage = "https://linphone.org/technical-corner/belle-sip";
    description = "Modern library implementing SIP (RFC 3261) transport, transaction and dialog layers. Part of the Linphone project.";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
