{
  lib,
  stdenv,
  fetchgit,
  nixosTests,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "tt-rss";
  version = "0-unstable-2025-03-19";

  src = fetchgit {
    url = "https://git.tt-rss.org/fox/tt-rss.git";
    rev = "5dcb8db933f1e49526137a55638d26f4d8d2d182";
    hash = "sha256-8iHWrfyV2Gm4P91E/1Y8Z58Um4r5a1mwJ1Y7vNYpIM8=";
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
    inherit (nixosTests) tt-rss;
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
  };

  meta = with lib; {
    description = "Web-based news feed (RSS/Atom) aggregator";
    license = licenses.gpl2Plus;
    homepage = "https://tt-rss.org";
    maintainers = with maintainers; [
      gileri
      globin
      zohl
    ];
    platforms = platforms.all;
  };
}
