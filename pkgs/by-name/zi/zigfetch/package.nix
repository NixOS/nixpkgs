{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_16,
  pciutils,
  apple-sdk,
  replaceVars,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "zigfetch";
  version = "0.27.2";

  src = fetchFromGitHub {
    owner = "utox39";
    repo = "zigfetch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PFZqtKgZYRRVXf0bNUKYFsahmJ9g2qcm58LFTR4ZzCU=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    (replaceVars ./darwin.patch {
      darwin-frameworks = "${apple-sdk.sdkroot}/System/Library/Frameworks";
    })
  ];

  nativeBuildInputs = [
    zig_0_16
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
    inherit (zig_0_16.meta) platforms;
  };
})
