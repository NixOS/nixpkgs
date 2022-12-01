{ lib, fetchFromGitHub }:

let
  pname = "junicode";
  version = "1.003";
in
fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "psb1558";
  repo = "Junicode-font";
  rev = "55d816d91a5e19795d9b66edec478379ee2b9ddb";

  postFetch = ''
    local out_ttf=$out/share/fonts/junicode-ttf
    mkdir -p $out_ttf
    tar -f $downloadedFile -C $out_ttf --wildcards -x '*.ttf' --strip=2
  '';

  sha256 = "1v334gljmidh58kmrarz5pf348b0ac7vh25f1xs3gyvn78khh5nw";

  meta = {
    homepage = "https://github.com/psb1558/Junicode-font";
    description = "A Unicode font for medievalists";
    maintainers = with lib.maintainers; [ ivan-timokhin ];
    license = lib.licenses.ofl;
  };
}
