{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "sweet";
  version = "1.10.5";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${version}/Sweet-Ambar-Blue.zip";
      sha256 = "11040hx8ci4vbnyaj63zj924v0ln7rjm9a28mcqdax60h3dp12lj";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${version}/Sweet-Ambar.zip";
      sha256 = "0lvnjmirpwdav8q0bfbhybwkr2h6dilc7lhhj18xd2k57xadjmxr";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${version}/Sweet-Dark.zip";
      sha256 = "0a7mh1pgvi8w1ahsmvgnmpdawm30lcjqk4zqvg0lqadsd04dn4h1";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${version}/Sweet-mars.zip";
      sha256 = "0n2dkl35qrik10wvhvkayyra987p03g56pxhz5kc73cbsl5zd96l";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${version}/Sweet.zip";
      sha256 = "0wwmc3wj2pjg4kimfkvcsimk3s4s7l7k000vxqi8yjlfs70f273c";
    })
  ];

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/themes/
    cp -a Sweet* $out/share/themes/
    rm $out/share/themes/*/{LICENSE,README*}
  '';

  meta = with stdenv.lib; {
    description = "Light and dark colorful Gtk3.20+ theme";
    homepage = "https://github.com/EliverLara/Sweet";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fuzen ];
    platforms = platforms.linux;
  };
}
