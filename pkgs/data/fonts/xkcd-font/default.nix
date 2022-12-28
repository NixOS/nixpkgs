{ lib, fetchFromGitHub }:

let
  pname = "xkcd-font";
  version = "unstable-2017-08-24";
in fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "ipython";
  repo = pname;
  rev = "5632fde618845dba5c22f14adc7b52bf6c52d46d";

  postFetch = ''
    install -Dm444 -t $out/share/fonts/opentype/ $out/xkcd/build/xkcd.otf
    install -Dm444 -t $out/share/fonts/truetype/ $out/xkcd-script/font/xkcd-script.ttf

    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';
  sha256 = "sha256-ITsJPs+ZXwUWYe2AmwyVZib8RV7bpiWHOUD8qEZRHHY=";

  meta = with lib; {
    description = "The xkcd font";
    homepage = "https://github.com/ipython/xkcd-font";
    license = licenses.cc-by-nc-30;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
