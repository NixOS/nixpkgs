{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "transmissionic";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "6c65726f79";
    repo = "Transmissionic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ROJljJuNqViNs2axQppxpbDByDL82yhbGIDDV9UQeZ8=";
  };

  npmDepsHash = "sha256-/Px6vthVCBw0vLhkeMNZ5VuZQWSr+iglYn4lUxKNEvE=";

  npmBuildScript = "build:webui";
  installPhase = ''
    runHook preInstall

    cp -r dist $out
    touch $out/default.json

    runHook postInstall
  '';

  meta = {
    description = "Remote for Transmission Daemon";
    homepage = "https://github.com/6c65726f79/Transmissionic";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stackptr ];
    platforms = lib.platforms.all;
  };
})
