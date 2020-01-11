{ stdenv
, fetchFromGitHub
, pantheon
, pkgconfig
, meson
, python3
, ninja
, vala
, desktop-file-utils
, gtk3
, granite
, libgee
, gcr
, webkitgtk
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-capnet-assist";
  version = "2.2.4";

  repoName = "capnet-assist";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "0yz827gs1qv6csgv4v993rjmqzc6dbymbvznsy45ghlh19l4l7j1";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
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
  patches = [
    ./remove-capnet-test.patch
  ];

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
