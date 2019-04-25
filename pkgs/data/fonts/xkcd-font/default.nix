{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "xkcd-font";
  version = "unstable-2017-08-24";

  src = fetchFromGitHub {
    owner = "ipython";
    repo = pname;
    rev = "5632fde618845dba5c22f14adc7b52bf6c52d46d";
    sha256 = "01wpfc1yp93b37r472mx2b459il5gywnv5sl7pp9afpycb3i4f6l";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    install -Dm444 -t $out/share/fonts/opentype/ xkcd/build/xkcd.otf
    install -Dm444 -t $out/share/fonts/truetype/ xkcd-script/font/xkcd-script.ttf
  '';

  meta = with stdenv.lib; {
    description = "The xkcd font";
    homepage = https://github.com/ipython/xkcd-font;
    license = licenses.cc-by-nc-30;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
