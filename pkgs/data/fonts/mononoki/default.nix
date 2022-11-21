{ lib, fetchzip }:

fetchzip {
  pname = "mononoki";
  version = "1.5";
  url = "https://github.com/madmalik/mononoki/releases/download/1.5/mononoki.zip";
  sha256 = "IM+D1AONLuOFy1wq114IsXKehJIliOgALKbRbIj/cX8=";
  stripRoot = false;

  postFetch = ''
    mkdir -pv $out/share/fonts/{opentype,truetype}
    cp -v $out/*.otf $out/share/fonts/opentype
    cp -v $out/*.ttf $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "A font for programming and code review";
    homepage = "https://madmalik.github.io/mononoki/";
    maintainers = with maintainers; [ totoroot ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
