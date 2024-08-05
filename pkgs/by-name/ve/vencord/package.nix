{
  stdenv,
  fetchFromGitHub,
  lib,
  git,
  nodejs,
  pnpm,
  esbuild,
  nix-update-script,
  buildWebExtension ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vencord";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "Vendicated";
    repo = "Vencord";
    rev = "v${finalAttrs.version}";
    # Allow Vencord to query the Git commit during build
    leaveDotGit = true;
    hash = "sha256-0FwUQZoaelo96CC95o9CAInIS740f1jx8CgSB6FKfB0=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname src;

    hash = "sha256-X7oMA8/P1Uf4bBI+Hu1y1REl70QGIc6rQrXj/vG1Cyo=";
  };

  nativeBuildInputs = [
    git
    nodejs
    pnpm.configHook
  ];

  env = {
    ESBUILD_BINARY_PATH = lib.getExe (
      esbuild.overrideAttrs (
        final: _: {
          version = "0.15.18";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            rev = "v${final.version}";
            hash = "sha256-b9R1ML+pgRg9j2yrkQmBulPuLHYLUQvW+WTyR/Cq6zE=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        }
      )
    );
    VENCORD_REMOTE = "${finalAttrs.src.owner}/${finalAttrs.src.repo}";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run ${if buildWebExtension then "buildWeb" else "build"} \
      -- --standalone --disable-updater

    runHook postBuild
  '';

  installPhase =
    if buildWebExtension then
      ''
        cp -r dist/chromium-unpacked/ $out
      ''
    else
      ''
        cp -r dist/ $out
      '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Vencord web extension";
    homepage = "https://github.com/Vendicated/Vencord";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      FlafyDev
      NotAShelf
      Scrumplex
    ];
  };
})
