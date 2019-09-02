{ stdenv, fetchurl }:

let
  fontconfig = fetchurl {
    name = "75-joypixels.conf";
    url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/75-joypixels.conf?h=packages/ttf-joypixels&id=b2b38f8393ec56ed7338c256f5b85f3439a2dfc3";
    sha256 = "065y2fmf86zzvna1hrvcg46cnr7a76xd2mwa26nss861dsx6pnd6";
  };
in stdenv.mkDerivation rec {
  pname = "emojione";
  version = "5.0.2";

  src = fetchurl {
    url = "https://cdn.joypixels.com/arch-linux/font/${version}/joypixels-android.ttf";
    sha256 = "0javgnfsh2nfddr5flf4yzi81ar8wx2z8w1q7h4fvdng5fsrgici";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm644 $src $out/share/fonts/truetype/joypixels.ttf
    install -Dm644 ${fontconfig} $out/etc/fonts/conf.d/75-joypixels.conf
  '';

  meta = with stdenv.lib; {
    description = "Emoji as a Service (formerly EmojiOne)";
    homepage = https://www.joypixels.com/;
    license = licenses.unfree;
    maintainers = with maintainers; [ jtojnar ];
  };
}
