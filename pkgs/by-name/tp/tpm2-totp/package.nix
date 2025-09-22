{
  lib,
  stdenv,
  fetchFromGitHub,
  tpm2-tss,
  autoreconfHook,
  autoconf-archive,
  pandoc,
  pkg-config,
  withPlymouth ? false,
  plymouth,
  qrencode,
}:

stdenv.mkDerivation rec {
  pname = "tpm2-totp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "tpm2-software";
    repo = "tpm2-totp";
    rev = "v${version}";
    hash = "sha256-aeWhI2GQcWa0xAqlmHfcbCMg78UqcD6eanLlEVNVnRM=";
  };

  preConfigure = ''
    echo '0.3.0' > VERSION
  '';

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pandoc
    pkg-config
  ];

  buildInputs = [
    tpm2-tss
    qrencode
  ]
  ++ lib.optional withPlymouth plymouth;

  meta = with lib; {
    description = "Attest the trustworthiness of a device against a human using time-based one-time passwords";
    homepage = "https://github.com/tpm2-software/tpm2-totp";
    changelog = "https://github.com/tpm2-software/tpm2-totp/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    mainProgram = "tpm2-totp";
    platforms = platforms.all;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
