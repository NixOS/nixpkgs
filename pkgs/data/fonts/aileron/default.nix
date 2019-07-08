{ lib, fetchzip }:

let
  majorVersion = "0";
  minorVersion = "102";
  pname = "aileron";
in

fetchzip rec {
  name = "${pname}-font-${majorVersion}.${minorVersion}";

  url = "http://dotcolon.net/DL/font/${pname}.zip";
  sha256 = "04xnzdy9plzd2p02yq367h37m5ygx0w8cpkdv39cc3754ljlsxim";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype/${pname}
    unzip -j $downloadedFile \*.otf  -d $out/share/fonts/opentype/${pname}
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${pname}/";
    description = "A helvetica font in nine weights";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.cc0;
  };
}
