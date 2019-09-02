{ lib, fetchFromGitHub }:

let
  pname = "nika-fonts";
  version = "1.0.0";
in fetchFromGitHub rec {
  name = "${pname}-${version}";
  owner = "font-store";
  repo = "NikaFont";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/nika-fonts {} \;
  '';
  sha256 = "1x34b2dqn1dymi1vmj5vrjcy2z8s0f3rr6cniyrz85plvid6x40i";

  meta = with lib; {
    homepage = https://github.com/font-store/NikaFont/;
    description = "Persian/Arabic Open Source Font";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
