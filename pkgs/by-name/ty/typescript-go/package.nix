{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  _experimental-update-script-combinators,
  nix-update-script,
  writeShellApplication,
  nix,
  gnugrep,
  gnused,
}:

let
  buildGoModule = buildGo126Module;
in
buildGoModule {
  pname = "typescript-go";
  version = "0-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "01cc06960f62a508d26232175e0fcfd16846ed4f";
    hash = "sha256-0xga15jY472BrOJmuWBaGoqThwhG8Bh4CoV+6Zm7ubk=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-n2wBDcMSKQGUJlTgCuJbKPTYOCiwkMpbvavqIrRvzS8=";

  ldflags = [
    "-s"
    "-w"
  ];

  env.CGO_ENABLED = 0;

  subPackages = [
    "cmd/tsgo"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    version="$("$out/bin/tsgo" --version)"
    [[ "$version" == *"7.0.0"* ]]

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        extraArgs = [
          "--version=branch"
          "--src-only"
        ];
      })

      (lib.getExe (writeShellApplication {
        name = "typescript-go-go-version-updater";
        runtimeInputs = [
          nix
          gnugrep
          gnused
        ];
        text = ''
          new_src="$(nix-build --attr 'pkgs.typescript-go.src' --no-out-link)"
          new_go_major_minor="$(grep --only-matching --perl-regexp '^go \K([0-9]+\.[0-9]+)' "$new_src/go.mod")"
          sed -i -E "s/buildGo[0-9]+Module/buildGo''${new_go_major_minor//./}Module/g" '${toString ./package.nix}'
        '';
      }))

      # Update vendorHash
      (nix-update-script {
        extraArgs = [ "--version=skip" ];
      })
    ];
  };

  meta = {
    description = "Go implementation of TypeScript";
    homepage = "https://github.com/microsoft/typescript-go";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "tsgo";
  };
}
