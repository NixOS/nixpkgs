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
  version = "4.45.3";

  src = fetchFromGitHub {
    owner = "mikefarah";
    repo = "yq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xa0kIdb/Y+1zqGulmQ3qR62E9q4s5CCooYvsUDsZN9E=";
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

  meta = with lib; {
    description = "Portable command-line YAML processor";
    homepage = "https://mikefarah.gitbook.io/yq/";
    changelog = "https://github.com/mikefarah/yq/raw/v${finalAttrs.version}/release_notes.txt";
    mainProgram = "yq";
    license = [ licenses.mit ];
    maintainers = with maintainers; [
      lewo
      SuperSandro2000
    ];
  };
})
