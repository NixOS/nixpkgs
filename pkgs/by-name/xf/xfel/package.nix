{
  fetchFromGitHub,
  lib,
  libusb1,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfel";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "xboot";
    repo = "xfel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5Io2qOIeGovDpbxSlmqtGMrGMxUjMu/e1304euTEtJc=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/usr/local" "$out" \
      --replace-fail "/etc" "$out/etc" \
      --replace-fail "/usr/share" "$out/share"
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ];

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
