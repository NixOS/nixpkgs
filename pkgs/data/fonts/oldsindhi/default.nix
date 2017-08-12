{ stdenv, fetchzip, p7zip }:

let
  version = "0.1";
in fetchzip rec {
  name = "oldsindhi-${version}";

  url = "https://github.com/MihailJP/oldsindhi/releases/download/0.1/OldSindhi-0.1.7z";

  postFetch = ''
    ${p7zip}/bin/7z x $downloadedFile

    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/${name}
    cp -v OldSindhi/*.ttf $out/share/fonts/truetype/
    cp -v OldSindhi/README OldSindhi/*.txt $out/share/doc/${name}
  '';

  sha256 = "1na3lxyz008fji5ln3fqzyr562k6kch1y824byhfs4y0rwwz3f3q";

  meta = with stdenv.lib; {
    homepage = https://github.com/MihailJP/oldsindhi;
    description = "Free Sindhi Khudabadi font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
