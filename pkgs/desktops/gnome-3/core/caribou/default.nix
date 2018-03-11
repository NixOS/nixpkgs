{ fetchurl, stdenv, pkgconfig, gnome3, clutter, dbus, python3Packages, libxml2
, libxklavier, libXtst, gtk2, intltool, libxslt, at-spi2-core, autoreconfHook
, wrapGAppsHook }:

let
  pname = "caribou";
  version = "0.4.21";
  pythonEnv = python3Packages.python.withPackages ( ps: with ps; [ pygobject3 ] );
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0mfychh1q3dx0b96pjz9a9y112bm9yqyim40yykzxx1hppsdjhww";
  };

  nativeBuildInputs = [ pkgconfig intltool libxslt libxml2 autoreconfHook wrapGAppsHook ];

  buildInputs = with gnome3;
    [ glib gtk clutter at-spi2-core dbus pythonEnv python3Packages.pygobject3
      libXtst gtk2 ];

  propagatedBuildInputs = [ gnome3.libgee libxklavier ];

  postPatch = ''
    patchShebangs .
    substituteInPlace libcaribou/Makefile.am --replace "--shared-library=libcaribou.so.0" "--shared-library=$out/lib/libcaribou.so.0"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "An input assistive technology intended for switch and pointer users";
    homepage = https://wiki.gnome.org/Projects/Caribou;
    platforms = platforms.linux;
    license = licenses.lgpl21;
    maintainers = gnome3.maintainers;
  };

}
