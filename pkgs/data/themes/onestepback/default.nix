{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "onestepback";
  version = "0.994";

  srcs = [
    (fetchurl {
      url = "http://www.vide.memoire.free.fr/perso/OneStepBack/OneStepBack-v${version}.zip";
      hash = "sha256-kjGiGo4bF1mWJPnaPv2lf7rGG/uAntHK61mH6lcJ6e4=";
    })
    (fetchurl {
      url = "http://www.vide.memoire.free.fr/perso/OneStepBack/OneStepBack-darker-v${version}.zip";
      hash = "sha256-AuurSa45uF5GbPqaMXKblWkv3YGkYL1z0VjWrbnsB/I=";
    })
  ];

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p  $out/share/themes
    cp -a OneStepBack* $out/share/themes/
    rm $out/share/themes/*/{LICENSE,README*}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Gtk theme inspired by the NextStep look";
    homepage = "http://www.vide.memoire.free.fr/perso/OneStepBack";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
