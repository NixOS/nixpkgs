{ stdenv, fetchurl, p7zip }:

let
  pname = "rounded-mgenplus";
  version = "20150602";

in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  inherit version;

  src = fetchurl {
    url = "https://osdn.jp/downloads/users/8/8598/${name}.7z";
    sha256 = "1k15xvzd3s5ppp151wv31wrfq2ri8v96xh7i71i974rxjxj6gspc";
  };

  nativeBuildInputs = [ p7zip ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    7z x $src
  '';

  installPhase = ''
    install -m 444 -D -t $out/share/fonts/${pname} ${pname}-*.ttf
  '';

  meta = with stdenv.lib; {
    description = "A Japanese font based on Rounded M+ and Noto Sans Japanese";
    homepage = http://jikasei.me/font/rounded-mgenplus/;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ mnacamura ];
  };
}
