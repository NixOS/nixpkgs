{ lib, fetchzip }:

let
  pname = "mno16";
  version = "1.0";
in fetchzip rec {
  name = "${pname}-${version}";
  url = "https://github.com/sevmeyer/${pname}/releases/download/${version}/${name}.zip";
  sha256 = "1x06nl281fcjk6g1p4cgrgxakmwcci6vvasskaygsqlzxd8ig87w";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "minimalist monospaced font";
    homepage = "https://sev.dev/fonts/mno16";
    license = licenses.cc0;
  };
}
