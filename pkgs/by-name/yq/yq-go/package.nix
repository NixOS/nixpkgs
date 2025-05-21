{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  runCommand,
  yq-go,
}:

buildGoModule (finalAttrs: {
  pname = "yq-go";
  version = "4.45.4";

  src = fetchFromGitHub {
    owner = "mikefarah";
    repo = "yq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qcsm7dB7F7Snul2PbH/7RdK17c5qT+mk+FvfqnFfuak=";
  };

  vendorHash = "sha256-cA5Y0/2lvYfVXr4zgtp/U8aBUkHnh9xb9jDHVk/2OME=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd yq \
      --bash <($out/bin/yq shell-completion bash) \
      --fish <($out/bin/yq shell-completion fish) \
      --zsh <($out/bin/yq shell-completion zsh)
  '';

  passthru.tests = {
    simple = runCommand "${finalAttrs.pname}-test" { } ''
      echo "test: 1" | ${yq-go}/bin/yq eval -j > $out
      [ "$(cat $out | tr -d $'\n ')" = '{"test":1}' ]
    '';
  };

  meta = {
    description = "Portable command-line YAML processor";
    homepage = "https://mikefarah.gitbook.io/yq/";
    changelog = "https://github.com/mikefarah/yq/raw/v${finalAttrs.version}/release_notes.txt";
    mainProgram = "yq";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [
      lewo
      prince213
      SuperSandro2000
    ];
  };
})
