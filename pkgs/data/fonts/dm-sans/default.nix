{ lib, fetchzip }:
let version = "1.002"; in
fetchzip {
  inherit version;
  pname = "dm-sans";
  url = "https://github.com/googlefonts/dm-fonts/releases/download/v${version}/DeepMindSans_v${version}.zip";
  stripRoot = false;
  hash = "sha256-zyS0gz7CGn39HCiyeN5cAP63v9nG6jffGSsI1vr84EQ=";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    mv $out/*.ttf $out/share/fonts/truetype
  '';

  meta = {
    description = "A geometric sans-serif typeface";
    homepage = "https://github.com/googlefonts/dm-fonts";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ gilice ];
  };
}
