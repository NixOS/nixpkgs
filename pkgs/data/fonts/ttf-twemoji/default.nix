{ lib
  , mkDerivation
  , fetchurl
  , rpm
  , cpio
}:

let
  _fedrel = "2.fc37";
in
mkDerivation rec {
  pname = "ttf-twemoji";
  version = "14.0.2";

  src = fetchurl {
    url = "https://kojipkgs.fedoraproject.org/packages/twitter-twemoji-fonts/${version}/${_fedrel}/noarch/twitter-twemoji-fonts-${version}-${_fedrel}.noarch.rpm";
    hash = "sha256-GK7JZzHs/9gSViSTPPv3V/LFfdGzj4F50VO5HSqs0VE=";
  };

  nativeBuildInputs = [
    rpm
    cpio
  ];

  unpackPhase = ''
    rpm2cpio $src | cpio -i --make-directories
  '';

  dontBuild = true;

  installPhase = ''
    install -Dm755 usr/share/fonts/twemoji/Twemoji.ttf $out/share/fonts/truetype/Twemoji.ttf
  '';

  meta = with lib; {
    description = "Twitter Color Emoji for everyone.";
    homepage = "https://github.com/twitter/twemoji";
    license = with licenses; [ cc-by-40 mit ];
    maintainers = with maintainers; [ elnudev ];
    platforms = platforms.all;
  };
}

