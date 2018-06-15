{stdenv, fetchzip}:

let
  version = "2014.10";
in fetchzip rec {
  name = "crimson-${version}";

  url = "https://github.com/skosch/Crimson/archive/fonts-october2014.tar.gz";

  postFetch = ''
    tar -xzvf $downloadedFile --strip-components=1

    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}
    cp -v "Desktop Fonts/OTF/"*.otf $out/share/fonts/opentype
    cp -v README.md $out/share/doc/${name}
  '';

  sha256 = "0mg65f0ydyfmb43jqr1f34njpd10w8npw15cbb7z0nxmy4nkl842";

  meta = with stdenv.lib; {
    homepage = https://aldusleaf.org/crimson.html;
    description = "A font family inspired by beautiful oldstyle typefaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
