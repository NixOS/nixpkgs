{ buildFontPackage, lib, fetchurl }:

buildFontPackage rec {
  pname = "agave";
  version = "16";

  src = fetchurl {
    url = "https://github.com/agarick/agave/releases/download/v${version}/Agave-Regular.ttf";
    downloadToTemp = true;
    recursiveHash = true;
    sha256 = "1d9651khizylqz15ixzyhawyzrl386l1ymsxb76s0j6j2acbhfii";
    postFetch = ''
      install -D $downloadedFile $out/Agave-Regular.ttf
    '';
  };

  meta = with lib; {
    description = "truetype monospaced typeface designed for X environments";
    homepage = "https://b.agaric.net/page/agave";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
