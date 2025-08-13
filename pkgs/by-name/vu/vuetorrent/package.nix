{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "vuetorrent";
  version = "2.28.2";

  src = fetchFromGitHub {
    owner = "VueTorrent";
    repo = "VueTorrent";
    tag = "v${version}";
    hash = "sha256-8n5OM55Z5xGLAXU6jqt2bKmrYa5ZnWatW0LsjOkJeDg=";
  };

  npmDepsHash = "sha256-Sh6s7zACAUu8j9ugST71j5u5nEWGVxC6dOniE+xjP6E=";

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
