{ lib, fetchzip }:

let
  version = "1.2";
in fetchzip {
  name = "mononoki-${version}";

  url = "https://github.com/madmalik/mononoki/releases/download/${version}/mononoki.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/mononoki
    unzip -j $downloadedFile -d $out/share/fonts/mononoki
  '';

  sha256 = "19y4xg7ilm21h9yynyrwcafdqn05zknpmmjrb37qim6p0cy2glff";

  meta = with lib; {
    homepage = https://github.com/madmalik/mononoki;
    description = "A font for programming and code review";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
