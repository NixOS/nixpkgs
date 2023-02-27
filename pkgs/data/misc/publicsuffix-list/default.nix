{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "unstable-2021-09-03";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "2533d032871e1ef1f410fc0754b848d4587c8021";
    hash = "sha256-moibTN9KovABcg+ubKUgMXg4b8sMrTVo6Itmiati/Vk=";
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
