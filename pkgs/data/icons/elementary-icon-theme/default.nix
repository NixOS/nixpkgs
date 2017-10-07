{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "4.3.0";

  package-name = "elementary-icon-theme";

  name = "${package-name}-${version}";

  src = fetchurl {
    url = "https://launchpad.net/elementaryicons/4.x/${version}/+download/${name}.tar.xz";
    sha256 = "1gg7znfgyj4zxsa741psc67nyixi27q9ghjklz0337r4cwmcwn1g";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/{icons,doc/$name}
    cp -dr --no-preserve='ownership' . $out/share/icons/Elementary/
    mv $out/share/icons/Elementary/{AUTHORS,CONTRIBUTORS,README.md} \
      $out/share/doc/$name/
    rm $out/share/icons/Elementary/{COPYING,pre-commit}
  '';

  meta = with stdenv.lib; {
    description = "Elementary icon theme";
    homepage = https://launchpad.net/elementaryicons;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ simonvandel ];
  };
}
