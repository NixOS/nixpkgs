{
  stdenv,
  lib,
  fetchFromGitHub,
  nodejs_20,
  git,
  pnpm_8,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vtsls";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "yioneko";
    repo = "vtsls";
    rev = "server-v${finalAttrs.version}";
    hash = "sha256-HCi9WLh4IEfhgkQNUVk6IGkQfYagg805Rix78zG6xt0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    nodejs_20
    git
    pnpm_8.configHook
  ];

  buildInputs = [ nodejs_20 ];

  pnpmWorkspace = "@vtsls/language-server";

  pnpmDeps = pnpm_8.fetchDeps {
    inherit (finalAttrs)
      pnpmWorkspace
      pname
      src
      version
      ;
    hash = "sha256-4XxQ0Z2atTBItrD9iY7q5rJaCmb1EeDBvQ5+L3ceRXI=";
  };

  # Patches to get submodule sha from file instead of 'git submodule status'
  patches = [ ./vtsls-build-patch.patch ];

  # Skips manual confirmations during build
  CI = true;

  buildPhase = ''
    runHook preBuild

    # During build vtsls needs a working git installation.
    git config --global user.name nixbld
    git config --global user.email nixbld@example.com

    # This is the sha for submodule packages/service/vscode. Unsure if there's a
    # better way to get this.
    echo "65d85f4cd0b4220fe8bb494898e001c7ad20e59b" > ./packages/service/HEAD

    # Requires a git repository during build
    git init packages/service/vscode

    # Depends on the @vtsls/language-service workspace
    # '--workspace-concurrency=1' helps debug failing builds.
    pnpm --filter "@vtsls/language-server..." build

    # These trash deterministic builds. During build the whole directory is
    # copied to another path.
    rm -rf packages/service/vscode/.git
    rm -rf packages/service/src/typescript-language-features/.git

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/vtsls-language-server}
    cp -r {packages,node_modules} $out/lib/vtsls-language-server
    ln -s $out/lib/vtsls-language-server/packages/server/bin/vtsls.js $out/bin/vtsls

    runHook postInstall
  '';

  meta = with lib; {
    description = "LSP wrapper for typescript extension of vscode.";
    homepage = "https://github.com/yioneko/vtsls";
    license = licenses.mit;
    maintainers = with maintainers; [ kuglimon ];
    mainProgram = "vtsls";
    platforms = platforms.all;
  };
})
