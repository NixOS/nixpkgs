{ lib, fetchzip }:

let
  pname = "junicode";
  version = "1.002";
in fetchzip {
  name = "${pname}-${version}";

  url = "mirror://sourceforge/junicode/junicode/junicode-${version}/junicode-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/junicode-ttf
  '';

  sha256 = "1n170gw41lr0zr5958z5cgpg6i1aa7kj7iq9s6gdh1cqq7hhgd08";

  meta = {
    homepage = "http://junicode.sourceforge.net/";
    description = "A Unicode font for medievalists";
    maintainers = with lib.maintainers; [ ivan-timokhin ];
    license = lib.licenses.ofl;
  };
}
