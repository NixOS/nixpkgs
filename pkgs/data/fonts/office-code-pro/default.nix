{ lib, fetchFromGitHub }:

let
  pname = "office-code-pro";
  version = "1.004";
in fetchFromGitHub rec {
  name = "${pname}-${version}";

  owner = "nathco";
  repo = "Office-Code-Pro";
  rev = version;

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -m644 -Dt $out/share/doc/${name} README.md
    install -m444 -Dt $out/share/fonts/opentype 'Fonts/Office Code Pro/OTF/'*.otf 'Fonts/Office Code Pro D/OTF/'*.otf
  '';
  sha256 = "1bagwcaicn6q8qkqazz6wb3x30y4apmkga0mkv8fh6890hfhywr9";

  meta = with lib; {
    description = "A customized version of Source Code Pro";
    longDescription = ''
      Office Code Pro is a customized version of Source Code Pro, the monospaced
      sans serif originally created by Paul D. Hunt for Adobe Systems
      Incorporated. The customizations were made specifically for text editors
      and coding environments, but are still very usable in other applications.
    '';
    homepage = https://github.com/nathco/Office-Code-Pro;
    license = licenses.ofl;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
