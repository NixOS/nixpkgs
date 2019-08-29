{ lib, fetchFromGitHub }:

let
  pname = "gandom-fonts";
  version = "0.6";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "rastikerdar";
  repo = "gandom-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/gandom-fonts {} \;
  '';
  sha256 = "0zsq6s9ziyb5jz0v8aj00dlxd1aly0ibxgszd05dfvykmgz051lc";

  meta = with lib; {
    homepage = https://github.com/rastikerdar/gandom-font;
    description = "A Persian (Farsi) Font - فونت (قلم) فارسی گندم";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
