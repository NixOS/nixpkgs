{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libtool
, autoreconfHook
, pcsclite, PCSC
, qrencode
, python3
, help2man
}:

stdenv.mkDerivation rec {
  pname = "vsmartcard-vpcd";
  version = "20220814";

  src = fetchFromGitHub {
    owner = "frankmorgner";
    repo = "vsmartcard";
    rev = "8b4aa3e7bfe891d986237759576b5ebf0e4ed42b";
    sha256 = "sha256-o01ASvHa68++wrHPLYxd452kHM0EAYQuMX8sbGjvvsg=";
  };

  sourceRoot = "source/virtualsmartcard";

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
    help2man
  ];

  buildInputs = [
    pcsclite
    qrencode
    (python3.withPackages (pp: with pp; [
      pyscard
      pycrypto
      pbkdf2
      pillow
      gnureadline
    ]))
  ] ++ lib.optionals stdenv.isDarwin [ PCSC ];

  configureFlags = [ ] ++ lib.optional stdenv.isDarwin "--enable-infoplist";

  meta = with lib; {
    description = "Emulates a smart card and makes it accessible through PC/SC";
    homepage = "http://frankmorgner.github.io/vsmartcard/virtualsmartcard/README.html";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ stargate01 ];
  };
}
