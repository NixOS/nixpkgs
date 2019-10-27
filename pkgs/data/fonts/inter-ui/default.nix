{ lib, fetchzip }:

# XXX: IMPORTANT:
# For compat, keep this at the last version that used the name "Inter UI"
# For newer versions, which are now simply named "Inter",
# see the expression for `inter` (../inter/default.nix).
let
  version = "3.2";
in fetchzip {
  name = "inter-ui-${version}";

  url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-UI-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "01d2ql803jrhss6g60djvs08x9xl7z6b3snkn03vqnrajdgifcl4";

  meta = with lib; {
    homepage = https://rsms.me/inter/;
    description = "A typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ demize ];
  };
}

