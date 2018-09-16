{ fetchurl, stdenv, pkgconfig, gnome3, glib, gtk3, clutter, dbus, python3, libxml2
, libxklavier, libXtst, gtk2, intltool, libxslt, at-spi2-core, autoreconfHook
, wrapGAppsHook }:

let
  pname = "caribou";
  version = "0.4.21";
  pythonEnv = python3.withPackages ( ps: with ps; [ pygobject3 ] );
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0mfychh1q3dx0b96pjz9a9y112bm9yqyim40yykzxx1hppsdjhww";
  };

  patches = [
    # Fix crash in GNOME Flashback
    # https://bugzilla.gnome.org/show_bug.cgi?id=791001
    (fetchurl {
      url = https://bugzilla.gnome.org/attachment.cgi?id=364774;
      sha256 = "15k1455grf6knlrxqbjnk7sals1730b0whj30451scp46wyvykvd";
    })
  ];

  nativeBuildInputs = [ pkgconfig intltool libxslt libxml2 autoreconfHook wrapGAppsHook ];

  buildInputs = [
    glib gtk3 clutter at-spi2-core dbus pythonEnv python3.pkgs.pygobject3
    libXtst gtk2
  ];

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
    license = licenses.lgpl21;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
