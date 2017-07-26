{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2016-03-03";
  name = "shrikhand-${version}";

  src = fetchFromGitHub {
    owner = "jonpinhorn";
    repo = "shrikhand";
    rev = "c11c9b0720fba977fad7cb4f339ebacdba1d1394";
    sha256 = "1d21bvj4w8i0zrmkdrgbn0rpzac89iazfids1x273gsrsvvi45kk";
  };

  installPhase = ''
    install -D -m644 build/Shrikhand-Regular.ttf $out/share/fonts/truetype/Shrikhand-Regular.ttf
  '';

  meta = with stdenv.lib; {
    homepage = https://jonpinhorn.github.io/shrikhand/;
    description = "A vibrant and playful typeface for both Latin and Gujarati writing systems";
    maintainers = with maintainers; [ sternenseemann ];
    platforms = platforms.all;
    license = licenses.ofl;
  };
}
