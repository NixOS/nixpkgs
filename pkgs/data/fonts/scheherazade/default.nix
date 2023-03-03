{ lib, stdenvNoCC, fetchzip, version ? "3.300" }:

let
  new = lib.versionAtLeast version "3.000";
  hash = {
    "2.100" = "sha256-d2UyOOOnmE1afCwyIrM1bL3lQC7XRwh03hzetk/4V30=";
    "3.300" = "sha256-LaaA6DWAE2dcwVVX4go9cJaiuwI6efYbPk82ym3W3IY=";
  }."${version}";
  pname = "scheherazade${lib.optionalString new "-new"}";
in
stdenvNoCC.mkDerivation rec {
  inherit pname version;

  src = fetchzip {
    url = "http://software.sil.org/downloads/r/scheherazade/Scheherazade${lib.optionalString new "New"}-${version}.zip";
    inherit hash;
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 FONTLOG.txt README.txt -t $out/share/doc
    cp -r documentation $out/share/doc/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://software.sil.org/scheherazade/";
    description = "A font designed in a similar style to traditional Naskh typefaces";
    longDescription = ''

      Scheherazade${lib.optionalString new " New"}, named after the heroine of
      the classic Arabian Nights tale, is designed in a similar style to
      traditional typefaces such as Monotype Naskh, extended to cover the
      Unicode Arabic repertoire through Unicode ${if new then "14.0" else "8.0"}.

      Scheherazade provides a “simplified” rendering of Arabic script, using
      basic connecting glyphs but not including a wide variety of additional
      ligatures or contextual alternates (only the required lam-alef
      ligatures). This simplified style is often preferred for clarity,
      especially in non-Arabic languages, but may not be considered appropriate
      in situations where a more elaborate style of calligraphy is preferred.

      This package contains the regular and bold styles for the Scheherazade
      font family, along with documentation.
    '';
    downloadPage = "https://software.sil.org/scheherazade/download/";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
