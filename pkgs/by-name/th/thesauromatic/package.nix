{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "thesauromatic";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = "thesauromatic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pDt+6/I6jON3988aliHxQv8mlunHz6ddsi4vIrdUMo0=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-odPhDNicnkj50g8L6GXxA6UvBzVp7lN5NUuRPqZcOtE=";

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/thesauromatic happy | grep -qx accidental
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line thesaurus that prints related words one per line";
    homepage = "https://github.com/cjrh/thesauromatic";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jtrv ];
    mainProgram = "thesauromatic";
  };
})
