{ stdenv
, fetchFromGitHub
, fetchpatch
, pantheon
, pkgconfig
, meson
, ninja
, python3
, vala
, desktop-file-utils
, gtk3
, libxml2
, granite
, libnotify
, vte
, libgee
, elementary-icon-theme
, appstream
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-terminal";
  version = "5.5.1";

  repoName = "terminal";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1b8fzs9s7djhwp02l3fwjpwxylklpbnw7x46mv7c8ksbp0m75iyj";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  patches = [
    # fix build with vte-2.91 https://github.com/elementary/terminal/pull/488
    (fetchpatch {
      url = "https://github.com/elementary/terminal/commit/48da5328cefdc481a3ac76fbdd771096f542d55a.patch";
      sha256 = "1y4043jxb0qzd3pp28kdij2yj1p9pg158il7q3aq1sf7c474gz4d";
    })
  ];

  nativeBuildInputs = [
    appstream
    desktop-file-utils
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
    libnotify
    vte
  ];

  # See https://github.com/elementary/terminal/commit/914d4b0e2d0a137f12276d748ae07072b95eff80
  mesonFlags = [ "-Dubuntu-bionic-patched-vte=false" ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Terminal emulator designed for elementary OS";
    longDescription = ''
      A super lightweight, beautiful, and simple terminal. Comes with sane defaults, browser-class tabs, sudo paste protection,
      smart copy/paste, and little to no configuration.
    '';
    homepage = "https://github.com/elementary/terminal";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
