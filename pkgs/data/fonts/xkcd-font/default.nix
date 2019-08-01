{ lib, fetchFromGitHub }:

let
  pname = "xkcd-font";
  version = "unstable-2017-08-24";
in fetchFromGitHub rec {
  name = "${pname}-${version}";

  owner = "ipython";
  repo = pname;
  rev = "5632fde618845dba5c22f14adc7b52bf6c52d46d";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -Dm444 -t $out/share/fonts/opentype/ xkcd/build/xkcd.otf
    install -Dm444 -t $out/share/fonts/truetype/ xkcd-script/font/xkcd-script.ttf
  '';
  sha256 = "0xhwa53aiz20763jb9nvbr2zq9k6jl69p07dc4b0apwrrwz0jfr1";

  meta = with lib; {
    description = "The xkcd font";
    homepage = https://github.com/ipython/xkcd-font;
    license = licenses.cc-by-nc-30;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
