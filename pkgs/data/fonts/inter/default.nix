{ lib
, fetchzip
# select a font type to install.
# Default is opentype with file extension '.otf'
, type ? "opentype"}:

let
  version = "3.18";
  exts = {
    "opentype" = ".otf";
    "truetype" = ".ttf";
  };
  hashes = {
    "opentype" = "sha256-+wbN1vSS8v1Z1VIfDNeY9DB8Kr6v7UnFg37EPPAD7wI=";
    "truetype" = "1an10lnp2pvd1syh9j6rmgwy9fxjz9m3fm2i3g93hghkv5p5r0kc";
  };

in

assert builtins.hasAttr type exts;
assert builtins.hasAttr type hashes;

let
  ext = builtins.getAttr type exts;
  sha256 = builtins.getAttr type hashes;
in fetchzip {
  name = "inter-${version}-${type}";

  url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/${type}
    unzip -j $downloadedFile \*${ext} -d $out/share/fonts/${type}
  '';

  inherit sha256;

  meta = with lib; {
    homepage = "https://rsms.me/inter/";
    description = "A typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ demize dtzWill ];
  };
}

