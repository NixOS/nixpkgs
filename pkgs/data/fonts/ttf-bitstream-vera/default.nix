{ lib, fetchzip }:
let
  pname = "ttf-bitstream-vera";
  version = "1.10";
in
fetchzip rec {
  name = "${pname}-${version}";

  url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.bz2";

  postFetch = ''
    tar -xjf $downloadedFile --strip-components=1
    install -m444 -Dt $out/share/fonts/truetype *.ttf
  '';

  sha256 = "179hal4yi3367jg8rsvqx6h2w4s0kn9zzrv8c47sslyg28g39s4m";

  meta = {
  };
}
