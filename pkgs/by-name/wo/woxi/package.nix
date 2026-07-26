{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  testers,
  makeBinaryWrapper,
  curl,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "woxi";
  version = "0.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ad-si";
    repo = "Woxi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iXRor0LU17ZDyFCXYwUz3vNp6+YbCpNDmnbTX/gof/s=";
  };

  cargoHash = "sha256-8FuiCitjDuWOkx06H0qjxHcPtc/F2tlaeaRwIznuWWc=";

  useNextest = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    curl
  ];

  postInstall = ''
    wrapProgram $out/bin/woxi \
      --prefix PATH : ${lib.makeBinPath [ curl ]}
  '';

  # NOTE: `SetDirectory[]` tests look up the $HOME directory.
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "Wolfram Language interpreter implemented in Rust";
    homepage = "https://woxi.ad-si.com/";
    downloadPage = "https://github.com/ad-si/Woxi";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      Dietr1ch
    ];
    mainProgram = "woxi";
    platforms = lib.platforms.unix;
  };
})
