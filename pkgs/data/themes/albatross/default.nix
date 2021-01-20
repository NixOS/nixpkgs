{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "Albatross";
  version = "1.7.4";

  src = fetchFromGitHub {
    repo = "Albatross";
    owner = "shimmerproject";
    rev = "v${version}";
    sha256 = "0mq87n2hxy44nzr567av24n5nqjaljhi1afxrn3mpjqdbkq7lx88";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/themes/Albatross
    cp -dr --no-preserve='ownership' {LICENSE.GPL,README,index.theme,gtk-2.0,gtk-3.0,metacity-1,xfwm4} $out/share/themes/Albatross/
  '';

  meta = {
    description = "A desktop Suite for Xfce";
    homepage = "https://github.com/shimmerproject/Albatross";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
