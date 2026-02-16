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
  version = "0-unstable-2026-02-15";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "4b301b2d3a6c626d0c932b6db182c63d9a98505e";
    hash = "sha256-IhK12tLjm2eTDcqsrX37lGssSieZgPNGao0w1DfduZ4=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-QNKXJ9HA8WlLlTxflLt0a/Y2Lt8NG1AnNmBOESYFyRI=";

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
