{ lib, fetchFromGitHub }:

let
  pname = "vazir-fonts";
  version = "22.1.0";
in fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "rastikerdar";
  repo = "vazir-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/truetype {} \;
  '';
  sha256 = "1nh3pyyw3082aizdwgyihh4z122z7kzp45ry7lzdhq9lshkpzglc";

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/vazir-font";
    description = "A Persian (Farsi) Font - قلم (فونت) فارسی وزیر";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
