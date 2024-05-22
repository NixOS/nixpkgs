{ lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "Everforest-GTK-Theme";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme/archive/refs/heads/master.tar.gz";
    sha256 = "2gmSMW/yUdinvZ/Jaw6GyfEL/CBqYKtw0QrYWy9KrL0=";
  };

  installPhase = ''
    mkdir -p $out/share/themes
    rm -rf README.md LICENSE icons extra
    cp -r themes/* $out/share/themes/
  '';

  meta = with lib; {
    description = "Everforest theme for GTK based desktop environments";
    homepage = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.OulipianSummer ];
  };
}
