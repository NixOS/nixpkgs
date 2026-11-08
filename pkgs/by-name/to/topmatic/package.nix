{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  systemd,
  topgrade,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "topmatic";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "c4i0b";
    repo = "topmatic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YNfNY3OK+bvteBiwh/+u+TLfHT/8OmZI1NbgLeIvBFk=";
  };

  cargoDepsName = finalAttrs.pname;
  cargoHash = "sha256-OjlMyxi35kBuenepkE6pBxJWAEOMrMAPMXMOKjRrqxw=";

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ systemd ];

  postInstall = ''
    wrapProgram $out/bin/topmatic \
      --prefix PATH : "${lib.makeBinPath [ topgrade ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "User-level scheduled updates powered by topgrade";
    homepage = "https://github.com/c4i0b/topmatic";
    changelog = "https://github.com/c4i0b/topmatic/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ c4i0b ];
    platforms = lib.platforms.linux;
    mainProgram = "topmatic";
  };
})
