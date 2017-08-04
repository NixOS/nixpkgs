{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "material-icons-${version}";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner  = "google";
    repo   = "material-design-icons";
    rev    = "${version}";
    sha256 = "17q5brcqyyc8gbjdgpv38p89s60cwxjlwy2ljnrvas5cj0s62np0";
  };

  buildCommand = ''
    mkdir -p $out/share/fonts/truetype
    cp $src/iconfont/*.ttf $out/share/fonts/truetype
  '';

  meta = with stdenv.lib; {
    description = "System status icons by Google, featuring material design";
    homepage = https://material.io/icons;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ mpcsh ];
  };
}
