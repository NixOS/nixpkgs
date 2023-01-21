# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "4.49.1";
in (fetchzip {
  name = "terminus-font-ttf-${version}";

  url = "https://files.ax86.net/terminus-ttf/files/${version}/terminus-ttf-${version}.zip";

  sha256 = "sha256-UaTnCamIRN/3xZsYt5nYzvykXQ3ri94a047sWOJ2RfU=";

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
}).overrideAttrs (_: {
  postFetch = ''
    unzip -j $downloadedFile

    for i in *.ttf; do
      local destname="$(echo "$i" | sed -E 's|-[[:digit:].]+\.ttf$|.ttf|')"
      install -Dm 644 "$i" "$out/share/fonts/truetype/$destname"
    done

    install -Dm 644 COPYING "$out/share/doc/terminus-font-ttf/COPYING"
  '';
})
