{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, python3, ninja, vala
, desktop-file-utils, gtk3, granite, libgee, gcr, webkitgtk, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "capnet-assist";
  version = "2.2.3";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "15cnwimkmmsb4rwvgm8bizcsn1krsj6k3qc88izn79is75y6wwji";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gcr
    granite
    gtk3
    libgee
    webkitgtk
  ];

  # Not useful here or in elementary - See: https://github.com/elementary/capnet-assist/issues/3
  patches = [ ./remove-capnet-test.patch ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "A small WebKit app that assists a user with login when a captive portal is detected";
    homepage = https://github.com/elementary/capnet-assist;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
