{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libtool
, autoreconfHook
, pcsclite
, qrencode
, python3
, help2man
, darwin
}:

stdenv.mkDerivation rec {
  pname = "vsmartcard-vpcd";
  version = "0.9-unstable-2024-05-14";

  src = fetchFromGitHub {
    owner = "frankmorgner";
    repo = "vsmartcard";
    rev = "509a14b44b229c44c33ad7f096ad1ad2d2c48729";
    sha256 = "sha256-F5zqrsTb3Fk0NNvqRJnneddsS/oJPB7pSPVh2iLxz3M=";
  };

  sourceRoot = "${src.name}/virtualsmartcard";

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
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.PCSC
  ];

  configureFlags = lib.optional stdenv.isDarwin "--enable-infoplist";

  meta = with lib; {
    description = "Emulates a smart card and makes it accessible through PC/SC";
    homepage = "http://frankmorgner.github.io/vsmartcard/virtualsmartcard/README.html";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ stargate01 ];
  };
}
