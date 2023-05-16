{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "terminus-font-ttf";
<<<<<<< HEAD
  version = "4.49.3";

  src = fetchzip {
    url = "https://files.ax86.net/terminus-ttf/files/${version}/terminus-ttf-${version}.zip";
    hash = "sha256-dK7MH4I1RhsIGzcnRA+7f3P5oi9B63RA+uASVDNtxNI=";
=======
  version = "4.49.1";

  src = fetchzip {
    url = "https://files.ax86.net/terminus-ttf/files/${version}/terminus-ttf-${version}.zip";
    hash = "sha256-NKswkZR05V21mszT56S2x85k//qhfzRShhepYaAybDc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
