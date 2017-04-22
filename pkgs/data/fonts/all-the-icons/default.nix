{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "all-the-icons-${version}";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "domtronn";
    repo = "all-the-icons.el";
    rev = version;
    sha256 = "125qw96rzbkv39skxk5511jrcx9hxm0fqcmny6213wzswgdn37z3";
  };

  installPhase = ''
    fontdir=$out/share/fonts/all-the-icons
    mkdir -p $fontdir
    cp -va fonts/*.ttf $fontdir
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/domtronn/all-the-icons.el";
    description = "Fonts included in the Emacs package all-the-icons";
    license = with licenses; [ asl20 mit ofl ];
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
