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
  version = "0-unstable-2025-04-17";

  src = fetchgit {
    url = "https://git.tt-rss.org/fox/tt-rss.git";
    rev = "be82663ac9b59de8a135178a519efe9f7ebae213";
    hash = "sha256-bZrmOOFB5HhiWsV6wWfqv3/wW4rf/05AX7qU+v1IBFE=";
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
