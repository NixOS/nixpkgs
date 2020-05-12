{ antlr3_4
, bctoolbox
, cmake
, fetchFromGitLab
, jre
, libantlr3c
, mbedtls
, stdenv
, zlib
}:

stdenv.mkDerivation rec {
  pname = "belle-sip";
  # Using master branch for linphone-desktop caused a chain reaction that many
  # of its dependencies needed to use master branch too.
  version = "unstable-2020-02-18";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = "0dcb13416eae87edf140771b886aedaf6be8cf60";
    sha256 = "0pzxk8mkkg6zsnmj1bwggbdjv864psx89gglfm51h8s501kg11fv";
  };

  nativeBuildInputs = [ jre cmake ];

  buildInputs = [ zlib ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=deprecated-declarations"
    "-Wno-error=format-truncation"
    "-Wno-error=cast-function-type"
  ];

  propagatedBuildInputs = [ antlr3_4 libantlr3c mbedtls bctoolbox ];

  # Fails to build with lots of parallel jobs
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    homepage = "https://linphone.org/technical-corner/belle-sip";
    description = "Modern library implementing SIP (RFC 3261) transport, transaction and dialog layers";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
