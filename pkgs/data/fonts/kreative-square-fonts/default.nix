{ lib, fetchFromGitHub }:

let
  pname = "kreative-square-fonts";
  version = "unstable-2021-01-29";
in
fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "kreativekorp";
  repo = "open-relay";
  rev = "084f05af3602307499981651eca56851bec01fca";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -Dm444 -t $out/share/fonts/truetype/ KreativeSquare/KreativeSquare.ttf
    install -Dm444 -t $out/share/fonts/truetype/ KreativeSquare/KreativeSquareSM.ttf
  '';
  sha256 = "15vvbbzv6b3jh7lxg77viycdd7yf3y8lxy54vs3rsrsxwncg0pak";

  meta = with lib; {
    description = "Fullwidth scalable monospace font designed specifically to support pseudographics, semigraphics, and private use characters";
    homepage = "https://www.kreativekorp.com/software/fonts/ksquare.shtml";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linus ];
  };
}
