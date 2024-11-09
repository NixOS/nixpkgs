{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "terminus-font-ttf";
  version = "4.49.3";

  src = fetchzip {
    url = "https://files.ax86.net/terminus-ttf/files/${version}/terminus-ttf-${version}.zip";
    hash = "sha256-dK7MH4I1RhsIGzcnRA+7f3P5oi9B63RA+uASVDNtxNI=";
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
    description = "Clean fixed width TTF font";
    longDescription = ''
      Monospaced bitmap font designed for long work with computers
      (TTF version, mainly for Java applications)
    '';
    homepage = "https://files.ax86.net/terminus-ttf";
    license = licenses.ofl;
    maintainers = [ ];
  };
}
