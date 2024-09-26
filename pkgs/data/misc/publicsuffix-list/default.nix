{ lib, stdenvNoCC, fetchFromGitHub, unstableGitUpdater }:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2024-08-21";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "30c3fc2db5ec0ecbc2efbb798b12459e9a22fffd";
    hash = "sha256-RmSlBl6lHFFvEEG2rsnwMpF9X8tv0VhPwhnke4UxUmA=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm0444 public_suffix_list.dat tests/test_psl.txt -t $out/share/publicsuffix

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://publicsuffix.org/";
    description = "Cross-vendor public domain suffix database";
    platforms = platforms.all;
    license = licenses.mpl20;
    maintainers = [ maintainers.c0bw3b ];
  };
}
