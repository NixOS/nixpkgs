{ lib
, fetchzip
}:

fetchzip rec {
  pname = "hackgen-font";
  version = "2.8.0";

  url = "https://github.com/yuru7/HackGen/releases/download/v${version}/HackGen_v${version}.zip";
  sha256 = "sha256-TLqns6ulovHRKoLHxxwKpj6SqfCq5UDVBf7gUASCGK4=";
  postFetch = ''
    install -Dm644 $out/*.ttf -t $out/share/fonts/hackgen
    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';

  meta = with lib; {
    description = "A composite font of Hack and GenJyuu-Goghic";
    homepage = "https://github.com/yuru7/HackGen";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ natsukium ];
  };
}
