{ lib, stdenvNoCC, fetchFromGitHub, unstableGitUpdater }:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2024-09-10";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "fbcc4c495e8aed1fe0e90156e6b3796556eb6978";
    hash = "sha256-L6TepLI91IWImX453GO8VNSSle75f0H1IZbFr2qepDA=";
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
