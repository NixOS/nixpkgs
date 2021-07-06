{ antlr3_4
, bctoolbox
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
  version = "4.5.14";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-L6dhgBJrzYgBuMNd2eMZJCqB/GIZjKipfn1SffxBFWw=";
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
