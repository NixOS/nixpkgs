{ lib, fetchFromGitHub }:

let
  version = "20180721";
in fetchFromGitHub {
  name = "ia-writer-duospace-${version}";

  owner = "iaolo";
  repo = "iA-Fonts";
  rev = "55edf60f544078ab1e14987bc67e9029a200e0eb";
  sha256 = "0932lcxf861vb3hz52z1xj8r99ag9sdyqsnq9brv7gc4kp2l339c";

  postFetch = ''
    tar --strip-components=1 -xzvf $downloadedFile
    mkdir -p $out/share/fonts/opentype
    cp "iA Writer Duospace/OTF (Mac)/"*.otf $out/share/fonts/opentype/
  '';

  meta = with lib; {
    description = "iA Writer Duospace Typeface";
    homepage = https://ia.net/topics/in-search-of-the-perfect-writing-font;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
