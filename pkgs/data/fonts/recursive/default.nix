{ lib, fetchzip }:

let
  version = "1.059";
in
fetchzip {
  name = "recursive-${version}";

  url = "https://github.com/arrowtype/recursive/releases/download/${version}/Recursive-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.woff2 -d $out/share/fonts/woff2
  '';

  sha256 = "0dlv8nrcqdn5vn3s918in5ph6kx6rg607kgp66p6ibpbg2s8ljy7";

  meta = with lib; {
    homepage = "https://recursive.design/";
    description = "A variable font family for code & UI";
    license = licenses.ofl;
    maintainers = [ maintainers.eadwu ];
    platforms = platforms.all;
  };
}
