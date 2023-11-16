{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "monaspace";
  version = "1.000";

  src = fetchzip {
    url = "https://github.com/githubnext/monaspace/releases/download/v${version}/monaspace-v${version}.zip";
    sha256 = "sha256-H8NOS+pVkrY9DofuJhPR2OlzkF4fMdmP2zfDBfrk83A=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -t $out/share/fonts/opentype/ $(find $src -type f -name '*.otf')

    runHook postInstall
  '';

  meta = with lib; {
    description = "An innovative superfamily of fonts for code";
    homepage = "https://github.com/githubnext/monaspace";
    license = [ licenses.ofl ];
    maintainers = [ maintainers.x0ba ];
    platforms = platforms.all;
  };
}
