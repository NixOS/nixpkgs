{ stdenv
, fetchFromGitHub
, pantheon
, wrapGAppsHook
, pkgconfig
, meson
, ninja
, vala
, gala
, gtk3
, libgee
, granite
, gettext
, mutter
, json-glib
, python3
}:

stdenv.mkDerivation rec {
  pname = "wingpanel";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "15pl3km8jfmlgrrb2fcabdd0rkc849arz6sc3vz6azzpln7gxbq7";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gala
    granite
    gtk3
    json-glib
    libgee
    mutter
  ];

  patches = [
    ./indicators.patch
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "The extensible top panel for Pantheon";
    longDescription = ''
      Wingpanel is an empty container that accepts indicators as extensions,
      including the applications menu.
    '';
    homepage = https://github.com/elementary/wingpanel;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
