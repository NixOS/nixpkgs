{ lib, fetchzip }:

let
  version = "2014.10";
in fetchzip rec {
  name = "crimson-${version}";

  url = "https://github.com/skosch/Crimson/archive/fonts-october2014.tar.gz";

  postFetch = ''
    tar -xzvf $downloadedFile --strip-components=1
    install -m444 -Dt $out/share/fonts/opentype "Desktop Fonts/OTF/"*.otf
    install -m444 -Dt $out/share/doc/${name}    README.md
  '';

  sha256 = "0mg65f0ydyfmb43jqr1f34njpd10w8npw15cbb7z0nxmy4nkl842";

  meta = with lib; {
    homepage = https://aldusleaf.org/crimson.html;
    description = "A font family inspired by beautiful oldstyle typefaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
