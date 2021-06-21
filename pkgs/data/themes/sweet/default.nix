{ lib, stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "sweet";
  version = "2.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/${version}/Sweet-Ambar-Blue.tar.xz";
      sha256 = "028pk07im7pab8a2vh3bvjm8jg37dpvn4c1mwn6vhb6wcr9v5c75";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/${version}/Sweet-Ambar.tar.xz";
      sha256 = "0zmdmqndj65kr43g3z57blrmv0y856zlfprm6y45zbf4xz3ybkg6";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/${version}/Sweet-Dark.tar.xz";
      sha256 = "02sw664fkrfpsygspq8fn4zgk8rxs9rd29nnx6nyvkji68mb51s6";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/${version}/Sweet-mars.tar.xz";
      sha256 = "14rl3il61jyqwiqlpgbh397q3rcs7jcf2pvr2763ar5a9czmy8h6";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/${version}/Sweet.tar.xz";
      sha256 = "0rza3yxwj256ibqimymjhd6lpjzr7fkhggq0ijdg1wab3q91x66q";
    })
  ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/
    cp -a Sweet* $out/share/themes/
    rm $out/share/themes/*/{LICENSE,README*}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Light and dark colorful Gtk3.20+ theme";
    homepage = "https://github.com/EliverLara/Sweet";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fuzen ];
    platforms = platforms.linux;
  };
}
