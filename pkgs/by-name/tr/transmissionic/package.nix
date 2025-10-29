{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "transmissionic";
  version = "v1.8.0";

  src = fetchFromGitHub {
    owner = "6c65726f79";
    repo = "Transmissionic";
    rev = version;
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

  meta = with lib; {
    description = "Remote for Transmission Daemon";
    homepage = "https://github.com/6c65726f79/Transmissionic";
    license = licenses.mit;
    maintainers = with maintainers; [
      stackptr
    ];
    platforms = platforms.all;
  };
}
