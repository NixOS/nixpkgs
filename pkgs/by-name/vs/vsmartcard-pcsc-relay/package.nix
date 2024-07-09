{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libtool
, autoreconfHook
, pcsclite
, libnfc
, python3
, help2man
, gengetopt
, vsmartcard-vpcd
, darwin
}:

stdenv.mkDerivation rec {
  pname = "vsmartcard-pcsc-relay";

  inherit (vsmartcard-vpcd) version src;

  sourceRoot = "${src.name}/pcsc-relay";

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
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.PCSC
  ];

  meta = with lib; {
    description = "Relays a smart card using an contact-less interface";
    homepage = "https://frankmorgner.github.io/vsmartcard/pcsc-relay/README.html";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ stargate01 ];
  };
}
