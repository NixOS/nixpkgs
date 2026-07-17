{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pinentry-tty,
}:

buildGoModule {
  pname = "tpm-fido";
  version = "0-unstable-2024-10-30";

  src = fetchFromGitHub {
    owner = "psanford";
    repo = "tpm-fido";
    rev = "5f8828b82b58f9badeed65718fca72bc31358c5c";
    hash = "sha256-Yfr5B4AfcBscD31QOsukamKtEDWC9Cx2ee4L6HM2554=";
  };

  vendorHash = "sha256-qm/iDc9tnphQ4qooufpzzX7s4dbnUbR9J5L770qXw8Y=";

  buildInputs = [
    pinentry-tty
  ];

  ldFlags = [
    "-s "
    "-w"
  ];

  meta = {
    description = "WebAuthn/U2F token protected by a TPM";
    homepage = "https://github.com/psanford/tpm-fido";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "tpm-fido";
  };
}
