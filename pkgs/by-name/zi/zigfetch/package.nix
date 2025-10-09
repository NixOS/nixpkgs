{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  pciutils,
  apple-sdk,
  replaceVars,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "zigfetch";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "utox39";
    repo = "zigfetch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WDCaU/qCwSCSCVD2gY2EuTM4KBJb+foZ+7REazp+dpY=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    (replaceVars ./darwin.patch {
      darwin-frameworks = "${apple-sdk.sdkroot}/System/Library/Frameworks";
    })
  ];

  nativeBuildInputs = [
    zig.hook
  ];

  buildInputs = [
    pciutils
  ];

  doInstallCheck = true;

  meta = {
    description = "Minimal neofetch/fastfetch like system information tool";
    homepage = "https://github.com/utox39/zigfetch";
    changelog = "https://github.com/utox39/zigfetch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ heisfer ];
    mainProgram = "zigfetch";
    inherit (zig.meta) platforms;
  };
})
