{ lib, stdenvNoCC, fetchurl, writeScript }:

stdenvNoCC.mkDerivation rec {
  pname = "i.ming";
  version = "8.00";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/ichitenfont/I.Ming/${version}/${version}/I.Ming-${version}.ttf";
    hash = "sha256-6345629OdKz6lTnD3Vjtp6DzsYy0ojaL0naXGrtdZvw=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -DT -m444 $src $out/share/fonts/truetype/I.Ming/I.Ming.ttf

    runHook postInstall
  '';

  passthru = {
    updateScript = writeScript "updater" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl gnused
      set -e
      version=$(curl -i -s https://github.com/ichitenfont/I.Ming/releases/latest | sed -n -E 's|^location.*releases/tag/([0-9.]+).*$|\1|p')
      if [[ $version != ${version} ]]; then
        tmp=$(mktemp -d)
        curl -Lo $tmp/I.Ming.ttf https://raw.githubusercontent.com/ichitenfont/I.Ming/$version/$version/I.Ming-$version.ttf
        install -DT -m444 $tmp/I.Ming.ttf $tmp/share/fonts/truetype/I.Ming/I.Ming.ttf
        rm $tmp/I.Ming.ttf
        hash=$(nix hash path --type sha256 --base32 --sri $tmp)
        sed -i -E \
          -e "s/version = \"[0-9.]+\"/version = \"$version\"/" \
          -e "s|hash = \".*\"|hash = \"$hash\"|" \
          pkgs/data/fonts/i-dot-ming/default.nix
      fi
    '';
  };

  meta = with lib; {
    description = "An open source Pan-CJK serif typeface";
    homepage = "https://github.com/ichitenfont/I.Ming";
    license = licenses.ipa;
    platforms = platforms.all;
    maintainers = [ maintainers.linsui ];
  };
}
