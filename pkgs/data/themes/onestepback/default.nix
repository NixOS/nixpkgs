{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "onestepback";
  version = "0.991";

  srcs = [
    (fetchurl {
      url = "http://www.vide.memoire.free.fr/perso/OneStepBack/OneStepBack-v${version}.zip";
      sha256 = "1jfgcgzbb6ra9qs3zcp6ij0hfldzg3m0yjw6l6vf4kq1mdby1ghm";
    })
    (fetchurl {
      url = "http://www.vide.memoire.free.fr/perso/OneStepBack/OneStepBack-grey-brown-green-blue-v${version}.zip";
      sha256 = "0i006h1asbpfdzajws0dvk9acplvcympzgxq5v3n8hmizd6yyh77";
    })
    (fetchurl {
      url = "http://www.vide.memoire.free.fr/perso/OneStepBack/OneStepBack-green-brown-v${version}.zip";
      sha256 = "16p002lak6425gcskny4hzws8x9dgsm6j3a1r08y11rsz7d2hnmy";
    })
  ];

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p  $out/share/themes
    cp -a OneStepBack* $out/share/themes/
    rm $out/share/themes/*/{LICENSE,README*}
  '';

  meta = with stdenv.lib; {
    description = "Gtk theme inspired by the NextStep look";
    homepage = "http://www.vide.memoire.free.fr/perso/OneStepBack";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
