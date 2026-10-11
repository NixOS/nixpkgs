{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  angular-cli,
  nodejs,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "vernissage-web";
  version = "1.43.0";

  src = fetchFromGitHub {
    owner = "VernissageApp";
    repo = "VernissageWeb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qxVYXGJZsOdvqImDwSfsFR2eoLx3IfffzqU+P/HTD3c=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      commit=$(git rev-parse --short HEAD) && sed -i -e "s/buildx/$commit/g" src/environments/environment.ts
    '';
  };
  npmDepsHash = "sha256-+4b50e+FdnCyRqtf98+fqcLghU7Zt7UrjI2JCpi93Xk=";

  strictDeps = true;

  nativeBuildInputs = [ angular-cli ];

  buildInputs = [ angular-cli ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -R dist $out/dist

    makeWrapper ${nodejs}/bin/node $out/bin/VernissageWeb \
      --add-flags "$out/dist/VernissageWeb/server/server.mjs"

    runHook postInstall
  '';

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vernissage web frontend";
    homepage = "https://github.com/VernissageApp/VernissageWeb";
    changelog = "https://github.com/VernissageApp/VernissageWeb/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "VernissageWeb";
  };
})
