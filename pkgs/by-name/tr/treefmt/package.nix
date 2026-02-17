{
  lib,
  stdenv,
  buildGoModule,
  callPackages,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "treefmt";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Okwwu5ls3BwLtm8qaq+QX3P+6uwuodV82F3j38tuszk=";
  };

  vendorHash = "sha256-fiBpyhbkzyhv7i4iHDTsgFcC/jx6onOzGP/YMcUAe9I=";

  subPackages = [ "." ];

  env.CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/numtide/treefmt/v2/build.Name=treefmt"
    "-X github.com/numtide/treefmt/v2/build.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd treefmt \
      --bash <($out/bin/treefmt --completion bash) \
      --fish <($out/bin/treefmt --completion fish) \
      --zsh <($out/bin/treefmt --completion zsh)
  '';

  passthru = {
    inherit (callPackages ./lib.nix { })
      evalConfig
      withConfig
      buildConfig
      ;

    tests = callPackages ./tests.nix { };

    # Documentation for functions defined in `./lib.nix`
    functionsDoc = callPackages ./functions-doc.nix { };

    # Documentation for options declared in `treefmt.evalConfig` configurations
    optionsDoc = callPackages ./options-doc.nix { };
  };

  meta = {
    description = "One CLI to format the code tree";
    longDescription = ''
      [treefmt](${finalAttrs.meta.homepage}) streamlines the process of applying formatters
      to your project, making it a breeze with just one command line.

      The `treefmt` package provides functions for configuring treefmt using
      the module system, which are documented in the [treefmt section] of the
      Nixpkgs Manual.

      Alternatively, treefmt can be configured using [treefmt-nix].

      [treefmt section]: https://nixos.org/manual/nixpkgs/unstable#treefmt
      [treefmt-nix]: https://github.com/numtide/treefmt-nix
    '';
    homepage = "https://github.com/numtide/treefmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      brianmcgee
      MattSturgeon
      zimbatm
    ];
    mainProgram = "treefmt";
  };
})
