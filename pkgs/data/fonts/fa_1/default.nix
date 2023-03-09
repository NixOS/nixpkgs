{ lib, stdenvNoCC, fetchzip }:

let
  majorVersion = "0";
  minorVersion = "100";
in
stdenvNoCC.mkDerivation (self: {
  pname = "fa_1";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/${self.pname}_${majorVersion}${minorVersion}.zip";
    hash = "sha256-BPJ+wZMYXY/yg5oEgBc5YnswA6A7w6V0gdv+cac0qdc=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${self.pname}/";
    description = "A weighted decorative font";
    platforms = platforms.all;
    maintainers = with maintainers; [ minijackson ];
    license = licenses.ofl;
  };
})
