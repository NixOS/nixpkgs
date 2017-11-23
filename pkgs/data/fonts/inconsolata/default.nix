{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "inconsolata-${version}";
  version = "2.001";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "4c3e95c802f8f12b78869ff50d552014de63f9c1";
    sha256 = "1ndmsf4c0k36dakmps0vr7hhg5ss8m7ywja7v55xdrinvli58v2f";
  };

  installPhase = ''
    install -m644 --target $out/share/fonts/truetype/inconsolata -D $src/ofl/inconsolata/*.ttf
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "04pdg5lzdid4b0gbzykia2jaiajc6pdbv5r8ml5ya9alyw30xza6";

  meta = with stdenv.lib; {
    homepage = http://www.levien.com/type/myfonts/inconsolata.html;
    description = "A monospace font for both screen and print";
    maintainers = with maintainers; [ mikoim raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
