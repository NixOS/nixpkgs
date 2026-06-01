{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  nodejs,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "watcharr";
  version = "3.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sbondCo";
    repo = "Watcharr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C0KQQuT6+KtbsgqvGp+dhqEAlUDq/ZsdIr089h+cXHM=";
  };

  modRoot = "server";
  vendorHash = "sha256-3JcOVWlnGnpvfcIvilMZPLBFLEmpwNbyJv41mQEnugs=";

  subPackages = [ "." ];

  # go-sqlite3 cgo build flag
  env.CGO_CFLAGS = "-D_LARGEFILE64_SOURCE";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mv $out/bin/Watcharr $out/bin/watcharr
    wrapProgram $out/bin/watcharr \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]} \
      --chdir ${finalAttrs.passthru.frontend}
  '';

  passthru = {
    frontend = buildNpmPackage {
      pname = "watcharr-frontend";
      inherit (finalAttrs) src version;

      npmDepsHash = "sha256-TKPgoHheA/9h/4VdRYeVw4zb5ZOBOATpUwM6jh26Tzo=";

      installPhase = ''
        runHook preInstall

        npm prune --omit=dev

        mkdir -p $out/ui
        cp -r build/. node_modules package.json $out/ui/

        runHook postInstall
      '';
    };

    tests = {
      inherit (nixosTests) watcharr;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Self-hosted watched list for movies, TV shows, anime, and games";
    homepage = "https://watcharr.app";
    changelog = "https://github.com/sbondCo/Watcharr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ miniharinn ];
    mainProgram = "watcharr";
    platforms = lib.platforms.linux;
  };
})
