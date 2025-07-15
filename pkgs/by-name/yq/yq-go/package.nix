{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  runCommand,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "yq-go";
  version = "4.46.1";

  src = fetchFromGitHub {
    owner = "mikefarah";
    repo = "yq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lMmcqAe1A/ET/2Dju6Gj0+I/g4z23EmtuRio0NYTHws=";
  };

  vendorHash = "sha256-wfn8u8I4dyAD4PbeiQGSai1gQ2ZDFBi2mysZVKa0mkA=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd yq \
      --bash <($out/bin/yq shell-completion bash) \
      --fish <($out/bin/yq shell-completion fish) \
      --zsh <($out/bin/yq shell-completion zsh)
  '';

  passthru = {
    tests = {
      simple = runCommand "yq-go-test" { } ''
        echo "test: 1" | ${finalAttrs.finalPackage}/bin/yq eval -j > $out
        [ "$(cat $out | tr -d $'\n ')" = '{"test":1}' ]
      '';
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Portable command-line YAML processor";
    homepage = "https://mikefarah.gitbook.io/yq/";
    changelog = "https://github.com/mikefarah/yq/raw/${finalAttrs.src.tag}/release_notes.txt";
    mainProgram = "yq";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [
      lewo
      prince213
      SuperSandro2000
    ];
  };
})
