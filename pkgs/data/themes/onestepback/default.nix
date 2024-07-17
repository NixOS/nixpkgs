{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "onestepback";
  version = "0.997";

  srcs = [
    (fetchurl {
      url = "http://www.vide.memoire.free.fr/pages/onestepback/OneStepBack-v${version}.zip";
      hash = "sha256-uB6pfnTkMKeP71rAvn1olJJeCL84222UT5uxG72sywE=";
    })
    (fetchurl {
      url = "http://www.vide.memoire.free.fr/pages/onestepback/OneStepBack-wm2-v${version}.zip";
      hash = "sha256-Zdv4ZrQPficbCxPBKF3RFNavlSn/VV/efiZVUT86zRc=";
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
    homepage = "http://www.vide.memoire.free.fr/pages/onestepback";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
