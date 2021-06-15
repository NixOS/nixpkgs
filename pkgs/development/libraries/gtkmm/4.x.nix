{ stdenv
, lib
, fetchurl
, pkg-config
, meson
, ninja
, python3
, gtk4
, glibmm_2_68
, cairomm_1_16
, pangomm_2_48
, epoxy
, gnome
, makeFontsConf
, xvfb-run
}:

stdenv.mkDerivation rec {
  pname = "gtkmm";
  version = "4.0.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-iXPZvHhI4CyyBR4F8+46S6/+L+tK9KVIfw4xMu7AOIQ=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
  ];

  buildInputs = [
    epoxy
  ];

  propagatedBuildInputs = [
    glibmm_2_68
    gtk4
    cairomm_1_16
    pangomm_2_48
  ];

  checkInputs = [
    xvfb-run
  ];

  # Tests require fontconfig.
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ ];
  };

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    xvfb-run -s '-screen 0 800x600x24' \
      meson test --print-errorlogs

    runHook postCheck
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "${pname}4";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "C++ interface to the GTK graphical user interface library";
    longDescription = ''
      gtkmm is the official C++ interface for the popular GUI library
      GTK.  Highlights include typesafe callbacks, and a
      comprehensive set of widgets that are easily extensible via
      inheritance.  You can create user interfaces either in code or
      with the Glade User Interface designer, using libglademm.
      There's extensive documentation, including API reference and a
      tutorial.
    '';
    homepage = "https://gtkmm.org/";
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ raskin ]);
    platforms = platforms.unix;
  };
}
