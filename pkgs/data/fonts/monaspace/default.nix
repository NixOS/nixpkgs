{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "monaspace";
  version = "1.000";

  src = fetchzip {
    url = "https://github.com/githubnext/monaspace/releases/download/v${version}/monaspace-v${version}.zip";
    hash = "sha256-H8NOS+pVkrY9DofuJhPR2OlzkF4fMdmP2zfDBfrk83A=";
    stripRoot = false;
  };

  outputs = [ "out" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/monaspace
    mkdir -p $out/share/fonts/monaspace-variable

    cp monaspace-v${version}/fonts/otf/*.otf $out/share/fonts/monaspace
    cp monaspace-v${version}/fonts/variable/*.ttf $out/share/fonts/monaspace-variable

    runHook postInstall
  '';

  meta = with lib; {
    description = "Monaspace";
    longDescription = "An innovative superfamily of fonts for code.";
    homepage = "https://monaspace.githubnext.com/";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
