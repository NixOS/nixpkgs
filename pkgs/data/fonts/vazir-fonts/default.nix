{ lib, fetchFromGitHub }:

let
  pname = "vazir-fonts";
  version = "32.0.0";
in fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "rastikerdar";
  repo = "vazir-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/truetype {} \;
  '';
  sha256 = "sha256-Uy8hgBtCcTLwXu9FkLN1WavUfP74Jf53ChxVGS3UBVM=";

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/vazir-font";
    description = "A Persian (Farsi) Font - قلم (فونت) فارسی وزیر";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
