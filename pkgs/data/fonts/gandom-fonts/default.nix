{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gandom-fonts";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "gandom-font";
    rev = "v${version}";
    sha256 = "1pdbqhvcsz6aq3qgarhfd05ip0wmh7bxqkmxrwa0kgxsly6zxz9x";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/gandom-fonts
    cp -v $( find . -name '*.ttf') $out/share/fonts/gandom-fonts
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/rastikerdar/gandom-font;
    description = "A Persian (Farsi) Font - فونت (قلم) فارسی گندم";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
