{ lib, fetchzip }:

let
  pname = "source-han-code-jp";
  version = "2.012R";
in fetchzip {
  name = "${pname}-${version}";

  url = "https://github.com/adobe-fonts/${pname}/archive/${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "16y5as1k864ghy3vzp8svr3q0sw57rv53za3f48700ksvxz5pwry";

  meta = {
    description = "A monospaced Latin font suitable for coding";
    maintainers = with lib.maintainers; [ mt-caret ];
    platforms = with lib.platforms; all;
    homepage = "https://blogs.adobe.com/CCJKType/2015/06/source-han-code-jp.html";
    license = lib.licenses.ofl;
  };
}
