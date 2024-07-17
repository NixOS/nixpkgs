{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "sil-padauk";
  version = "5.001";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/padauk/Padauk-${version}.zip";
    hash = "sha256-rLzuDUd+idjTN0xQxblXQ9V2rQtJPN2EtWGmTRY1R7U=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv *.ttf $out/share/fonts/truetype/
    mkdir -p $out/share/doc/${pname}-${version}
    mv *.txt documentation/ $out/share/doc/${pname}-${version}/

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Unicode-based font family with broad support for writing systems that use the Myanmar script";
    homepage = "https://software.sil.org/padauk";
    license = licenses.ofl;
    maintainers = with maintainers; [ serge ];
    platforms = platforms.all;
  };
}
