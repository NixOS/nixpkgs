{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule {
  pname = "zoekt";
  version = "3.7.2-2-unstable-2025-10-24";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "eab7bf421ca319e3096b3b5192c7b0c32647c335";
    hash = "sha256-vG/btpXRI/8G98iakevtHOG4yEOx7EsrWHCLApAIQMQ=";
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
