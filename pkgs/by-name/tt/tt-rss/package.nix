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
  version = "0-unstable-2025-10-19";

  src = fetchgit {
    url = "https://github.com/tt-rss/tt-rss.git";
    rev = "f12f46bd6e9d186c0854c15ce4edde229143b848";
    hash = "sha256-lpb7aum7EkpHFT0kcMwiH83qAjL2iSso+jKeKqk63so=";
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
