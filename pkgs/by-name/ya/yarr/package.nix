{
  lib,
  stdenv,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "yarr";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "nkanaev";
    repo = "yarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NvYcl+i3JW18zjYUT1C+ksMJgUJQGP+90UhTQkZRhD4=";
  };

  assets = buildNpmPackage {
    pname = "${finalAttrs.pname}-assets";
    inherit (finalAttrs) version src;
    npmDepsHash = "sha256-T0KGV5fkroPp9K5cRp5CEnDku1nNzwTW9lUxXQFAQZc=";
    installPhase = ''
      runHook preInstall
      cp -r src/assets/static "$out"
      runHook postInstall
    '';
  };

  postPatch = ''
    cp ${finalAttrs.assets}/bundle.{css,js} src/assets/static
  '';

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
    "-X main.GitHash=none"
  ];

  tags = [
    "sqlite_foreign_keys"
    "sqlite_json"
    "sqlite_fts5"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  checkFlags = [ "-short" ]; # skip docker tests

  passthru = {
    updateScript = nix-update-script { };
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux nixosTests.yarr;
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Yet another rss reader";
    mainProgram = "yarr";
    homepage = "https://github.com/nkanaev/yarr";
    changelog = "https://github.com/nkanaev/yarr/blob/v${finalAttrs.version}/doc/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sikmir
      christoph-heiss
    ];
  };
})
