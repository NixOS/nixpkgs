{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule {
  pname = "zoekt";
  version = "3.7.2-2-unstable-2025-09-02";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "4e4a529c3b63c7d4c7897ba736f1cd52cc163134";
    hash = "sha256-aRQQAG0qZOrkdbQoQRXeddhMmQaB+/ESD6Ba+q4UIlI=";
  };

  vendorHash = "sha256-urXYBv8+C2jwnr5PjXz7nUyX/Gz4wmtS76UTXFqfQFk=";

  nativeCheckInputs = [
    gitMinimal
  ];

  preCheck = ''
    export HOME=`mktemp -d`
    git config --global --replace-all protocol.file.allow always
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Fast trigram based code search";
    homepage = "https://github.com/sourcegraph/zoekt";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "zoekt";
  };
}
