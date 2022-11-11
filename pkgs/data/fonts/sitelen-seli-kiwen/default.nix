{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "sitelen-seli-kiwen";
  version = "1.1";

  src = fetchzip {
    url = "https://github.com/kreativekorp/sitelen-seli-kiwen/raw/6f11eb55061ad7e1a5b9cb86e509a364986d04d9/sitelenselikiwen.zip";
    sha256 = "sha256-pNFBdXJRrMXiobno65tTaXcWgvYd3Dlte023lu0A6DI=";
    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    install -Dm755 -t $out/share/fonts/truetype *.ttf
  '';

  meta = with lib; {
    description = "handwritten sitelen pona font";
    homepage = "https://github.com/kreativekorp/sitelen-seli-kiwen";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.jan-senaa ];
  };
}

