{ lib, fetchFromGitHub }:

let
  pname = "lalezar-fonts";
  version = "unstable-2017-02-28";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "BornaIz";
  repo = "Lalezar";
  rev = "238701c4241f207e92515f845a199be9131c1109";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    mkdir -p $out/share/fonts/lalezar-fonts
    cp -v $( find . -name '*.ttf') $out/share/fonts/lalezar-fonts
  '';
  sha256 = "0jmwhr2dqgj3vn0v26jh6c0id6n3wd6as3bq39xa870zlk7v307b";

  meta = with lib; {
    homepage = https://github.com/BornaIz/Lalezar;
    description = "A multi-script display typeface for popular culture";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
