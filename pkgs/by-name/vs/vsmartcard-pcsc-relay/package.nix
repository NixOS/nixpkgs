{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libtool
, autoreconfHook
, pcsclite, PCSC
, libnfc
, python3
, help2man
, gengetopt
}:

stdenv.mkDerivation rec {
  pname = "vsmartcard-pcsc-relay";
  version = "20220814";

  src = fetchFromGitHub {
    owner = "frankmorgner";
    repo = "vsmartcard";
    rev = "8b4aa3e7bfe891d986237759576b5ebf0e4ed42b";
    sha256 = "sha256-o01ASvHa68++wrHPLYxd452kHM0EAYQuMX8sbGjvvsg=";
  };

  sourceRoot = "source/pcsc-relay";

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
    help2man
  ];

  buildInputs = [
    pcsclite
    libnfc
    gengetopt
    (python3.withPackages (pp: with pp; [
      pyscard
      pycrypto
      pbkdf2
      pillow
      gnureadline
    ]))
  ] ++ lib.optionals stdenv.isDarwin [ PCSC ];

  meta = with lib; {
    description = "Relays a smart card using an contact-less interface";
    homepage = "https://frankmorgner.github.io/vsmartcard/pcsc-relay/README.html";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ stargate01 ];
  };
}
