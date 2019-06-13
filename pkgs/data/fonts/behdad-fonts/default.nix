{ lib, fetchFromGitHub }:

let
  pname = "behdad-fonts";
  version = "0.0.3";
in fetchFromGitHub rec {
  name = "${pname}-${version}";
  owner = "font-store";
  repo = "BehdadFont";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/behrad-fonts {} \;
  '';
  sha256 = "0c57232462cv1jrfn0m2bl7jzcfkacirrdd2qimrc8iqhkz0ajfz";

  meta = with lib; {
    homepage = https://github.com/font-store/BehdadFont;
    description = "A Persian/Arabic Open Source Font";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
