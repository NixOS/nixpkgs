{ lib, fetchzip }:

fetchzip rec {
  pname = "lxgw-wenkai";
  version = "1.250";

  url = "https://github.com/lxgw/LxgwWenKai/releases/download/v${version}/lxgw-wenkai-v${version}.tar.gz";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    mv $out/*.ttf $out/share/fonts/truetype

    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';

  hash = "sha256-kzV+1rWVxvQXR/WxlM/AmmBMtyOtWGWtw88DHCBjkuc=";

  meta = with lib; {
    homepage = "https://lxgw.github.io/";
    description = "An open-source Chinese font derived from Fontworks' Klee One";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ elliot ];
  };
}
