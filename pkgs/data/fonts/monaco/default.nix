{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "monaco";
  version = "unstable-2012-06-03";

  src = fetchFromGitHub {
    owner = "todylu";
    repo = "monaco.ttf";
    rev = "d258639b562cab674da79e9e3316998e709e8960";
    sha256 = "0kdnn01gb08j0cdmnv8l7xym8fm7mz2jpwk3yvihbmq92pq0hjb9";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/monaco
    cp -v $( find . -name '*.ttf') $out/share/fonts/monaco
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/todylu/monaco.ttf;
    description = "A monospaced sans-serif typeface by Apple Inc";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
