{ lib, stdenvNoCC, fetchurl, xorg }:

stdenvNoCC.mkDerivation rec {
  pname = "spleen";
<<<<<<< HEAD
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/fcambus/spleen/releases/download/${version}/spleen-${version}.tar.gz";
    hash = "sha256-d4d4s13UhwG4A9skemrIdZFUzl/Dq9XMC225ikS6Wgw=";
=======
  version = "1.9.3";

  src = fetchurl {
    url = "https://github.com/fcambus/spleen/releases/download/${version}/spleen-${version}.tar.gz";
    hash = "sha256-t60e2wKl3a0RfKlPAm64RQtRUE0ugbw6A4deEtTnayU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ xorg.mkfontscale ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    d="$out/share/fonts/misc"
    install -D -m 644 *.{pcf,bdf,otf} -t "$d"
    install -D -m 644 *.psfu -t "$out/share/consolefonts"
    install -m644 fonts.alias-spleen $d/fonts.alias

    # create fonts.dir so NixOS xorg module adds to fp
    mkfontdir "$d"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Monospaced bitmap fonts";
    homepage = "https://www.cambus.net/spleen-monospaced-bitmap-fonts";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
