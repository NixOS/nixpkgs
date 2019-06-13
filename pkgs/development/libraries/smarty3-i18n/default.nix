{ stdenv, fetchFromGitHub, ... }: stdenv.mkDerivation rec {
  name = "smarty-i18n-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "kikimosha";
    repo = "smarty3-i18n";
    rev = "${version}";
    sha256 = "0rjxq4wka73ayna3hb5dxc5pgc8bw8p5fy507yc6cv2pl4h4nji2";
  };

  installPhase = ''
    mkdir $out
    cp block.t.php $out
  '';

  meta = with stdenv.lib; {
    description = "gettext for the smarty3 framework";
    license = licenses.lgpl21;
    homepage = https://github.com/kikimosha/smarty3-i18n;
    maintainers = with maintainers; [ das_j ];
    platforms = platforms.all;
  };
}
