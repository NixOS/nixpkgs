{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2024-01-07";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "5db9b65997e3c9230ac4353b01994c2ae9667cb9";
    hash = "sha256-kIJVS2ETAXQa1MMG8cjRUSFUn+jm9jBWH8go3L+lqHE=";
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
