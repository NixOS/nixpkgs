{ lib
, fetchzip
}:

fetchzip rec {
  pname = "hackgen-nf-font";
  version = "2.8.0";

  url = "https://github.com/yuru7/HackGen/releases/download/v${version}/HackGen_NF_v${version}.zip";
  sha256 = "sha256-xRFedeavEJY9OZg+gePF5ImpLTYdbSba5Wr9k0ivpkE=";
  postFetch = ''
    install -Dm644 $out/*.ttf -t $out/share/fonts/hackgen-nf
    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';

  meta = with lib; {
    description = "A composite font of Hack, GenJyuu-Gothic and nerd-fonts";
    homepage = "https://github.com/yuru7/HackGen";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ natsukium ];
  };
}
