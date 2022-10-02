{ lib, fetchzip }:

let version = "1.222"; in
fetchzip {
  name = "lxgw-wenkai-${version}";
  url = "https://github.com/lxgw/LxgwWenKai/releases/download/v${version}/lxgw-wenkai-v${version}.tar.gz";

  postFetch = ''
    tar -xzvf $downloadedFile --strip-components=1
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  sha256 = "sha256-u2NTEYZrotOHktc2R5RWMFqeZ775/IpYJSUBO6PWijM=";

  meta = with lib; {
    homepage = "https://lxgw.github.io/";
    description = "An open-source Chinese font derived from Fontworks' Klee One";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ elliot ];
  };
}
