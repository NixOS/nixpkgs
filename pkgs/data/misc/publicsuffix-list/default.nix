{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "unstable-2023-02-16";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "8ec4d3049fe139f92937b6137155c33b81dcaf18";
    hash = "sha256-wA8zk0iADFNP33veIf+Mfx22zdMzHsMNWEizMp1SnuA=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm0444 public_suffix_list.dat tests/test_psl.txt -t $out/share/publicsuffix

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://publicsuffix.org/";
    description = "Cross-vendor public domain suffix database";
    platforms = platforms.all;
    license = licenses.mpl20;
    maintainers = [ maintainers.c0bw3b ];
  };
}
