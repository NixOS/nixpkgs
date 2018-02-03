{ stdenv, fetchurl, pkgconfig, intltool, mate-menus, pythonPackages }:

stdenv.mkDerivation rec {
  name = "mozo-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "04yn9bw64q5a5kvpmkb7rb3mlp11pmnvkbphficsgb0368fj895b";
  };
  
  pythonPath = [ mate-menus pythonPackages.pygobject3 ];

  nativeBuildInputs = [ pkgconfig intltool pythonPackages.wrapPython ];

  buildInputs = [ pythonPackages.python ] ++ pythonPath;

  preFixup = "wrapPythonPrograms";

  meta = with stdenv.lib; {
    description = "MATE Desktop menu editor";
    homepage = https://github.com/mate-desktop/mozo;
    license = with licenses; [ lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
