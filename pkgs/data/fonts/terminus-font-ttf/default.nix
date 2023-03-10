{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "terminus-font-ttf";
  version = "4.49.1";

  src = fetchzip {
    url = "https://files.ax86.net/terminus-ttf/files/${version}/terminus-ttf-${version}.zip";
    hash = "sha256-NKswkZR05V21mszT56S2x85k//qhfzRShhepYaAybDc=";
  };

  installPhase = ''
    runHook preInstall

    for i in *.ttf; do
      local destname="$(echo "$i" | sed -E 's|-[[:digit:].]+\.ttf$|.ttf|')"
      install -Dm 644 "$i" "$out/share/fonts/truetype/$destname"
    done

    install -Dm 644 COPYING "$out/share/doc/terminus-font-ttf/COPYING"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A clean fixed width TTF font";
    longDescription = ''
      Monospaced bitmap font designed for long work with computers
      (TTF version, mainly for Java applications)
    '';
    homepage = "https://files.ax86.net/terminus-ttf";
    license = licenses.ofl;
    maintainers = with maintainers; [ ];
  };
}
