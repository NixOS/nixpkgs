# nixpkgs-update: no auto update
{
  lib,
  stdenv,
  fetchgit,
  nixosTests,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "tt-rss";
  version = "0-unstable-2025-11-01";

  src = fetchgit {
    url = "https://github.com/tt-rss/tt-rss.git";
    rev = "912162ad811869af334232d32fe6c79b3cf095ca";
    hash = "sha256-2U9V4MTWGNZzdVr9AlH/S7KdBGPap+mm5/KieWLcF1A=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -ra * $out/

    # see the code of Config::get_version(). you can check that the version in
    # the footer of the preferences pages is not UNKNOWN
    echo "${version}" > $out/version_static.txt

    runHook postInstall
  '';

  passthru = {
    tests = { inherit (nixosTests) tt-rss; };
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
  };

  meta = with lib; {
    description = "Web-based news feed (RSS/Atom) aggregator";
    license = licenses.gpl3Plus;
    homepage = "https://tt-rss.org";
    maintainers = with maintainers; [
      gileri
      globin
      zohl
    ];
    platforms = platforms.all;
  };
}
