{ lib, fetchFromGitHub }:

let
  pname = "RhodiumLibre";
  version = "1.2.0";
in fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "DunwichType";
  repo = pname;
  rev = version;

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -Dm444 -t $out/share/fonts/opentype/ RhodiumLibre-Regular.otf
    install -Dm444 -t $out/share/fonts/truetype/ RhodiumLibre-Regular.ttf
  '';

  sha256 = "04ax6bri5vsji465806p8d7zbdf12r5bpvcm9nb8isfqm81ggj0r";

  meta = with lib; {
    description = "F/OSS/Libre font for Latin and Devanagari";
    homepage = "https://github.com/DunwichType/RhodiumLibre";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
