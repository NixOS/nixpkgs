{ lib, pkgs, stdenvNoCC, fetchzip }:

let
  version = "4.0";
in stdenvNoCC.mkDerivation {
  pname = "inter-nerdfont";
  inherit version;

  src = fetchzip {
    url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-${version}.zip";
    stripRoot = false;
    hash = "sha256-hFK7xFJt69n+98+juWgMvt+zeB9nDkc8nsR8vohrFIc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    nerd-font-patcher Inter.ttc
    cp 'Inter Nerd Font.ttc' $out/share/fonts/truetype/InterNerdFont.tcc
    cp *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  buildInputs = builtins.attrValues {
    inherit (pkgs)
      fontforge
      nerd-font-patcher;
  };

  meta = {
    homepage = "https://gitlab.com/mid_os/inter-nerdfont";
    description = "A NerdFont patch of the Inter font";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.cvoges12 ];
  };
}
