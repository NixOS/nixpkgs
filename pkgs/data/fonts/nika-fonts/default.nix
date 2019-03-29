{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nika-fonts";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "font-store";
    repo = "NikaFont";
    rev = "v${version}";
    sha256 = "16dhk87vmjnywl5wqsl9dzp12ddpfk57w08f7811m3ijqadscdwc";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/nika-fonts
    cp -v $( find . -name '*.ttf') $out/share/fonts/nika-fonts
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/font-store/NikaFont/;
    description = "Persian/Arabic Open Source Font";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
