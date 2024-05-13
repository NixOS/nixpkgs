{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  autoconf,
  automake,
}:

buildNpmPackage rec {
  pname = "textlint";
  version = "14.0.4";

  src = fetchFromGitHub {
    owner = "textlint";
    repo = "textlint";
    rev = "refs/tags/v${version}";
    hash = "sha256-u8BRzfvpZ8xggJwH8lsu+hqsql6s4SZVlkFzLBe6zvE=";
  };

  patches = [
    # this package uses lerna and requires building many workspaces.
    # this patch removes unnecessary workspaces,
    # reducing package size and build time.
    ./remove-workspaces.patch
  ];

  npmDepsHash = "sha256-rmRtCP51rt/wd/ef0iwMMI6eCGF1KNN7kJqomitMJ+w=";

  nativeBuildInputs = [
    autoconf
    automake
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    npm prune --omit=dev --no-save
    rm -r node_modules/.cache
    rm -r packages/textlint-{scripts,tester}
    rm -r packages/@textlint/*/test

    cp -r node_modules $out/lib
    cp -r packages $out/lib
    ln -s $out/lib/node_modules/textlint/bin/textlint.js $out/bin/textlint

    runHook postInstall
  '';

  meta = {
    description = "The pluggable natural language linter for text and markdown";
    homepage = "https://github.com/textlint/textlint";
    changelog = "https://github.com/textlint/textlint/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "textlint";
  };
}
