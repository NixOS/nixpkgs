{ lib, fetchzip }:

fetchzip {
  name = "ipafont-003.03";

  url = "http://ipafont.ipa.go.jp/old/ipafont/IPAfont00303.php";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/opentype
  '';

  sha256 = "0lrjd0bfy36f9j85m12afg5nvr5id3sig2nmzs5qifskbd7mqv9h";

  meta = {
    description = "Japanese font package with Mincho and Gothic fonts";
    longDescription = ''
      IPAFont is a Japanese font developed by the Information-technology
      Promotion Agency of Japan. It provides both Mincho and Gothic fonts,
      suitable for both display and printing.
    '';
    homepage = http://ipafont.ipa.go.jp/ipafont/;
    license = lib.licenses.ipa;
    maintainers = [ lib.maintainers.auntie ];
  };
}
