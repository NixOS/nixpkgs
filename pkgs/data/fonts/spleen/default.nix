{ lib, stdenvNoCC, fetchurl, xorg }:

stdenvNoCC.mkDerivation rec {
  pname = "spleen";
  version = "1.9.1";

  src = fetchurl {
    url = "https://github.com/fcambus/spleen/releases/download/${version}/spleen-${version}.tar.gz";
    hash = "sha256-fvWcTgKkXp3e1ryhi1Oc3w8OtJ5svLJXhY2lasXapiI=";
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
