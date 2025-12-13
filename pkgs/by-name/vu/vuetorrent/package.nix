{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "vuetorrent";
  version = "2.31.0";

  src = fetchFromGitHub {
    owner = "VueTorrent";
    repo = "VueTorrent";
    tag = "v${version}";
    hash = "sha256-jWoD54cO1Tq9b2k8ySWUWQohT4qE0rW9EVJLoPi8DTA=";
  };

  npmDepsHash = "sha256-/B/DMTH/5e9YNJ9rl+HTGkAX1KzOoBB1PD68Li2sAAw=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r vuetorrent $out/share/vuetorrent

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Full-featured BitTorrent client written in Vue";
    homepage = "https://github.com/VueTorrent/VueTorrent";
    changelog = "https://github.com/VueTorrent/VueTorrent/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ redxtech ];
  };
}
