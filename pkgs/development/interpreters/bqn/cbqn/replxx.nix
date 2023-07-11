{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "replxx";
  version = "unstable-2023-02-26";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "replxx";
    rev = "1da4681a8814366ec51e7630b76558e53be0997d";
    hash = "sha256-Zs7ItuK31n0VSxwOsPUdZZLr68PypitZqcydACrx90Q=";
  };

  dontConfigure = true;
  # The CBQN derivation will build replxx, here we just provide the source files.
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/dev
    cp -r $src $out/dev

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/dzaima/replxx";
    description = "A replxx fork for CBQN";
    license = licenses.free;
    maintainers = with maintainers; [ AndersonTorres sternenseemann synthetica shnarazk detegr ];
    platforms = platforms.all;
  };
}
