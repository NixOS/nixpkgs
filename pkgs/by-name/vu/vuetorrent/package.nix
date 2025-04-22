{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "vuetorrent";
  version = "2.24.1";

  src = fetchFromGitHub {
    owner = "VueTorrent";
    repo = "VueTorrent";
    tag = "v${version}";
    hash = "sha256-FuX1wZVWB6+5G0ePE7Eb4Gkq736UKB/caW5AcCYJtUU=";
  };

  npmDepsHash = "sha256-lRTB4Wfkp9UAi0N9iOSJQIJNFBz3RDGTglFofWqIWZ0=";

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
