{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "phinger-cursors";
  version = "1.1";

  src = fetchurl {
    url = "https://github.com/phisch/phinger-cursors/releases/download/v${version}/phinger-cursors-variants.tar.bz2";
    sha256 = "sha256-II+1x+rcjGRRVB8GYkVwkKVHNHcNaBKRb6C613901oc=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r ./phinger-cursors* $out/share/icons
    runHook postInstall
  '';

  meta = with lib; {
    description = "The most over-engineered cursor theme";
    homepage = "https://github.com/phisch/phinger-cursors";
    platforms = platforms.unix;
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ moni ];
  };
}
