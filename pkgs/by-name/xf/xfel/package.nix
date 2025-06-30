{
  fetchFromGitHub,
  lib,
  libusb1,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfel";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "xboot";
    repo = "xfel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fmf+jqCWC7RaLknr/TyRV6VQz4+fp83ynHNk2ACkyfQ=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX=/"
  ];

  doInstallCheck = true;

  meta = {
    description = "Tooling for working with the FEL mode on Allwinner SoCs";
    homepage = "https://github.com/xboot/xfel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixsinger ];
    platforms = lib.platforms.linux;
    mainProgram = "xfel";
  };
})
