{ lib
, stdenv
, fetchurl
, buildPythonPackage
, pkg-config
, glib
, gobject-introspection
, pycairo
, cairo
, ncurses
, meson
, ninja
, isPy3k
, gnome
}:

buildPythonPackage rec {
  pname = "pygobject";
  version = "3.42.1";

  outputs = [ "out" "dev" ];

  disabled = !isPy3k;

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "HzS192JN415E61p+tCg1MoW9AwBNVRMaX39/qbkPPMk=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gobject-introspection
  ];

  buildInputs = [
    glib
    gobject-introspection
  ] ++ lib.optionals stdenv.isDarwin [
    ncurses
  ];

  propagatedBuildInputs = [
    pycairo
    cairo
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "python3.pkgs.${pname}3";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://pygobject.readthedocs.io/";
    description = "Python bindings for Glib";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
