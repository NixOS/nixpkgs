{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "sonic-${version}";
  version = "2016-03-01";

  src = fetchFromGitHub {
    owner = "waywardgeek";
    repo = "sonic";
    rev = "71bdf26c55716a45af50c667c0335a9519e952dd";
    sha256 = "1kcl8fdf92kafmfhvyjal5gvkn99brkjyzbi9gw3rd5b30m3xz2b";
  };

  postPatch = ''
    sed -i "s,^PREFIX=.*,PREFIX=$out," Makefile
  '';

  meta = with stdenv.lib; {
    description = "Simple library to speed up or slow down speech";
    homepage = "https://github.com/waywardgeek/sonic";
    license = licenses.asl20;
    maintainers = with maintainers; [ aske ];
    platforms = platforms.linux;
  };
}
