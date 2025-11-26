{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pandoc,
  runCommand,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "yq-go";
  version = "4.49.2";

  src = fetchFromGitHub {
    owner = "mikefarah";
    repo = "yq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r+9TjdVRcHx5Ijea/4ITCqyJIngEcfzrCBP3Xlgd1xE=";
  };

  vendorHash = "sha256-fcjHqWLDvXyALkh3TR8lOnv7McXUVtcb1VpVbMuUMtk=";

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
    pandoc
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd yq \
      --bash <($out/bin/yq shell-completion bash) \
      --fish <($out/bin/yq shell-completion fish) \
      --zsh <($out/bin/yq shell-completion zsh)

    patchShebangs ./scripts/generate-man-page*
    export MAN_HEADER="yq (https://github.com/mikefarah/yq/) version ${finalAttrs.version}"
    ./scripts/generate-man-page-md.sh
    ./scripts/generate-man-page.sh
    installManPage yq.1
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
