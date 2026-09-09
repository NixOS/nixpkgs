{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  _experimental-update-script-combinators,
  versionCheckHook,
  nix-update-script,
  writeShellApplication,
  nix,
  gnugrep,
  gnused,
}:

let
  buildGoModule = buildGo126Module;
in
buildGoModule (finalAttrs: {
  pname = "typescript-go";
  version = "7.0.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j1AY4sf/Jb6uwOah35lrYooc7BnSeaZ2NO6Fx1zMj60=";
  };

  modRoot = "tsc";

  vendorHash = "sha256-q6dMb2ab4uZ3GTrcA7v2JzfmOM+ZzBcJN6gKOpLfM/k=";

  tags = [
    # Prevent LSP issues. In embed mode, "Go to Definition" fails for built-in types:
    #   - https://github.com/microsoft/typescript-go/pull/4197
    #   - https://github.com/microsoft/typescript-go/pull/3840
    "noembed"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  env.CGO_ENABLED = 0;

  subPackages = [
    "cmd/tsgo"
  ];

  # When built with the "noembed" tag, the executable must be under "lib/${pname}/" to resolve its paths.
  postInstall = ''
    lib_dir="$out/lib/${finalAttrs.pname}"
    mkdir -p "$lib_dir"
    cp -r internal/bundled/libs/. "$lib_dir"

    mv "$out/bin/tsgo" "$lib_dir/tsc"

    ln -s "$lib_dir/tsc" "$out/bin/tsc"
    ln -s "$lib_dir/tsc" "$out/bin/tsgo"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        extraArgs = [
          "--use-github-releases"
          "--version-regex=^v([\\d.]+)$"
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
          new_go_major_minor="$(grep --only-matching --perl-regexp '^go \K([0-9]+\.[0-9]+)' "$new_src/tsc/go.mod")"
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
    homepage = "https://github.com/microsoft/typescript";
    changelog = "https://github.com/microsoft/typescript/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "tsc";
  };
})
