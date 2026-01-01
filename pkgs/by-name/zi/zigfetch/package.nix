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
<<<<<<< HEAD
  version = "0.25.0";
=======
  version = "0.24.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "utox39";
    repo = "zigfetch";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-n5bVIkg/jMVLixIfMp1ah4iJJLv59MoH4/acvFye4vQ=";
=======
    hash = "sha256-ciAMz4zw8+SgMMsrjQUGBkSMMNtMJSo2KbyE2RlRYDc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
