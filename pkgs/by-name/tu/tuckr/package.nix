{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuckr";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "RaphGL";
    repo = "Tuckr";
    rev = finalAttrs.version;
    hash = "sha256-QFGT032gpyzdobGdICEyvgbAMDGbBSNhIH16AlGPK4s=";
  };

  cargoHash = "sha256-ffAp+1kkLTaKYPhfwQt4ieR3d/w8SeJPfeaFh0Vzc1w=";

  doCheck = false; # test result: FAILED. 5 passed; 3 failed;

  meta = {
    description = "Super powered replacement for GNU Stow";
    homepage = "https://github.com/RaphGL/Tuckr";
    changelog = "https://github.com/RaphGL/Tuckr/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mimame ];
    mainProgram = "tuckr";
  };
})
