{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "parastoo-fonts";
  version = "1.0.0-alpha5";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "parastoo-font";
    rev = "v${version}";
    sha256 = "1nya9cbbs6sgv2w3zyah3lb1kqylf922q3fazh4l7bi6zgm8q680";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/parastoo-fonts
    cp -v $( find . -name '*.ttf') $out/share/fonts/parastoo-fonts
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/rastikerdar/parastoo-font;
    description = "A Persian (Farsi) Font - فونت ( قلم ) فارسی پرستو";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
