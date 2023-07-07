{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "ankacoder";
  version = "1.100";

  src = fetchzip {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/anka-coder-fonts/AnkaCoder.${version}.zip";
    stripRoot = false;
    hash = "sha256-14ItaSQ/fO/WDq0O4SXGWnZgiM0kayJrWQgsKb7bsyY=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Anka/Coder fonts";
    homepage = "https://code.google.com/archive/p/anka-coder-fonts";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
