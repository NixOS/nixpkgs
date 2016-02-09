{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  version = "3.2.2";

  package-name = "elementary-icon-theme";

  name = "${package-name}-${version}";

  src = fetchzip {
    url = "https://launchpad.net/elementaryicons/3.x/${version}/+download/elementary-icon-theme-${version}.tar.xz";
    sha256 = "0b6sgvkzc5h9zm3la6f0ngs9pfjrsj318qcynxd3yydb50cd3hnf";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' . $out/share/icons/Elementary/
  '';

  meta = with stdenv.lib; {
  description = "Elementary icon theme";
  homepage = "https://launchpad.net/elementaryicons";
  license = licenses.gpl3;
  platforms = platforms.all;
  maintainers = with maintainers; [ simonvandel ];
  };
}
