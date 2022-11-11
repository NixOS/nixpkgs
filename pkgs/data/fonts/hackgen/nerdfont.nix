{ lib
, fetchzip
}:

fetchzip rec {
  pname = "hackgen-nf-font";
  version = "2.7.1";

  url = "https://github.com/yuru7/HackGen/releases/download/v${version}/HackGen_NF_v${version}.zip";
  sha256 = "sha256-9sylGr37kKIGWgThZFqL2y6oI3t2z4kbXYk5DBMIb/g=";
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
