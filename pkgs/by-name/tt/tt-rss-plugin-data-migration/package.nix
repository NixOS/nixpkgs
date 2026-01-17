{
  lib,
  stdenv,
  fetchgit,
}:

stdenv.mkDerivation {
  pname = "tt-rss-plugin-data-migration";
  version = "0-unstable-2023-11-01";

  src = fetchgit {
    url = "https://git.tt-rss.org/fox/ttrss-data-migration.git";
    rev = "e13d5f97b4887ce7b57b3d76228d838dec15963d";
    hash = "sha256-xnbR5IQ0h7ilxchNj55ROZdq1L7MIAwv3/00k09WTTs=";
  };

  installPhase = ''
    runHook preInstall

    install -D init.php $out/data_migration/init.php

    runHook postInstall
  '';

  meta = {
    description = "Plugin for TT-RSS to exports and imports *all* articles of a specific user via neutral format (JSON files in a ZIP archive)";
    # this plugin doesn't have a license file
    license = lib.licenses.unfree;
    homepage = "https://git.tt-rss.org/fox/ttrss-data-migration.git/";
    maintainers = with lib.maintainers; [ wrvsrx ];
    platforms = lib.platforms.all;
  };
}
