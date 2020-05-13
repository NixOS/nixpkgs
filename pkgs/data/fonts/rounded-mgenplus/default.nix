{ lib, fetchzip, libarchive }:

let
  pname = "rounded-mgenplus";
  version = "20150602";
in fetchzip rec {
  name = "${pname}-${version}";

  url = "https://osdn.jp/downloads/users/8/8598/${name}.7z";
  postFetch = ''
    ${libarchive}/bin/bsdtar xf $downloadedFile
    install -m 444 -D -t $out/share/fonts/${pname} ${pname}-*.ttf
  '';
  sha256 = "0vwdknagdrl5dqwpb1x5lxkbfgvbx8dpg7cb6yamgz71831l05v1";

  meta = with lib; {
    description = "A Japanese font based on Rounded M+ and Noto Sans Japanese";
    homepage = "http://jikasei.me/font/rounded-mgenplus/";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ mnacamura ];
  };
}
