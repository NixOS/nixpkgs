{ lib, stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "updfparser";
  version = "unstable-2022-03-16";

  src = fetchgit {
    url = "git://soutade.fr/updfparser";
    rev = "9d56c1d0b1ce81aae4c8db9d99a8b5d1f7967bcf";
    sha256 = "sha256-9dvibKiUbbI4CrmuAaJzlpntT0XdLvdGeC2/WzjlA5U=";
  };

  installPhase = ''
    runHook preInstall
    install -Dt $out/include include/*.h
    install -Dt $out/lib libupdfparser.so
    runHook postInstall
  '';

  meta = with lib; {
    description = "A very simple PDF parser";
    homepage = "https://indefero.soutade.fr/p/updfparser";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ McSinyx ];
    platforms = platforms.all;
  };
}
