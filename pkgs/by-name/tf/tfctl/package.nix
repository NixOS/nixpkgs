{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  kubectl,
  writeScript,
}:
let
  commitHash = "a53488094851773978301511922c2ced1397cdf9"; # matches tag release
  shortCommitHash = builtins.substring 0 8 commitHash;
in
buildGoModule (finalAttrs: {
  pname = "tfctl";
  version = "0.15.1";
  src = fetchFromGitHub {
    owner = "flux-iac";
    repo = "tofu-controller";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rA3HLO4sD8UmcebGGFxyg0zFpDHCzFHjHwMxPw8MiRU=";
  };
  vendorHash = "sha256-NhXgWuxSuurP46DBWOviFzCINJKaTb1mINRYeYcnnH8=";

  subPackages = [ "cmd/tfctl" ];
  ldflags = [
    "-X main.BuildSHA=${shortCommitHash}"
    "-X main.BuildVersion=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  patchPhase = ''
    substituteInPlace tfctl/break_glass.go \
      --replace-fail 'exec.Command("kubectl"' 'exec.Command("${lib.getExe kubectl}"'
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash zsh fish ; do
      $out/bin/tfctl completion "$shell" > "tfctl.$shell"
    done

    installShellCompletion tfctl.{bash,zsh,fish}
  '';

  passthru.updateScript = writeScript "update-tfctl" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq nix-update

    set -eu -o pipefail

    gh_metadata="$(curl -LsS https://api.github.com/repos/flux-iac/tofu-controller/tags)"
    version="$(echo "$gh_metadata" | jq -r '.[] | select(.name | test("rc") | not) | .name' | sort --version-sort | tail -1)"
    commit_hash="$(echo "$gh_metadata" | jq -r --arg ver "$version" '.[] | select(.name == $ver).commit.sha')"

    filename="$(nix-instantiate --eval -E "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" tfctl).file" | tr -d '"')"
    sed -i "s/commitHash = \"[^\"]*\"/commitHash = \"$commit_hash\"/" $filename

    nix-update tfctl
  '';

  meta = {
    homepage = "https://github.com/flux-iac/tofu-controller";
    description = "Cli for managing tofu-controller";
    mainProgram = "tfctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lunkentuss
    ];
  };
})
