{ stdenv, fetchFromGitHub, pantheon, pkgconfig
, meson, ninja, vala, desktop-file-utils, libxml2
, gtk3, python3, granite, libgee, gobject-introspection
, elementary-icon-theme, appstream, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "calculator";
  version = "1.5.2";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1vdgl89hdf9q1ya6as7310hlr0xls3w7js2gzsd9z8arb6037ccl";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-${pname}";
    };
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gobject-introspection
    libxml2
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
    granite
    gtk3
    libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/elementary/calculator;
    description = "Calculator app designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
