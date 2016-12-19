{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "4.0.1.1";

  package-name = "elementary-icon-theme";

  name = "${package-name}-${version}";

  src = fetchurl {
    url = "https://launchpad.net/elementaryicons/4.x/${version}/+download/${name}.tar.xz";
    sha256 = "1p20569lxgkif4gzvgpisd8vg93zxd6447y634lv7ay85nq4lx76";
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
    homepage = "https://launchpad.net/elementaryicons";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ simonvandel ];
  };
}
