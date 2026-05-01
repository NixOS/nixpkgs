{
  lib,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "wanderer";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "open-wanderer";
    repo = "wanderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FaHWJwHpITt1AWVMykZNtPHXdmwpBVrkzzEBNQcwZRg=";
  };

  sourceRoot = "${finalAttrs.src.name}/db";

  vendorHash = "sha256-70tr+t7R1B0maLuu01HaFgANSbN6Rr2PUxcFjc/5xw0=";

  postInstall = ''
    mv $out/bin/pocketbase $out/bin/wanderer

    mkdir -p $out/share/wanderer
    cp -r migrations/initial_data $out/share/wanderer/initial_data
  '';

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  passthru = {
    web = callPackage ./web.nix { wanderer = finalAttrs.finalPackage; };
    plugins = lib.genAttrs [ "hammerhead" "komoot" "strava" ] (
      id:
      callPackage ./plugin.nix {
        inherit id;
        wanderer = finalAttrs.finalPackage;
      }
    );
    tests = { inherit (nixosTests) wanderer; };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "web"
      ];
    };
  };

  meta = {
    description = "Self-hosted trail database for storing and managing GPS tracking data";
    mainProgram = "wanderer";
    homepage = "https://wanderer.to";
    changelog = "https://github.com/open-wanderer/wanderer/releases/tag/${finalAttrs.src.tag}";
    downloadPage = "https://github.com/open-wanderer/wanderer";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      charludo
      maartenbehn
    ];
  };
})
