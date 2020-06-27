{ lib, mkFont, fetchurl, p7zip }:

mkFont rec {
  pname = "rounded-mgenplus";
  version = "20150602";

  src = fetchurl {
    url = "https://osdn.jp/downloads/users/8/8598/${pname}-${version}.7z";
    sha256 = "1k15xvzd3s5ppp151wv31wrfq2ri8v96xh7i71i974rxjxj6gspc";
  };

  nativeBuildInputs = [ p7zip ];
  sourceRoot = ".";

  meta = with lib; {
    description = "A Japanese font based on Rounded M+ and Noto Sans Japanese";
    homepage = "http://jikasei.me/font/rounded-mgenplus/";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ mnacamura ];
  };
}
