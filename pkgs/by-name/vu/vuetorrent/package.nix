{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "vuetorrent";
  version = "2.23.1";

  src = fetchFromGitHub {
    owner = "VueTorrent";
    repo = "VueTorrent";
    tag = "v${version}";
    hash = "sha256-cOt/JxceEET8g8hyQbhz9tYf4zH2i5YYG7eQ9/EjA0M=";
  };

  npmDepsHash = "sha256-gjvJEY+XZeRJNwVi0hSfbdFnuIJbY8CVsJqyMqi7wD0=";

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
