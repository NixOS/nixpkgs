{ stdenv
, fetchFromGitHub
, nix-update-script
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
  version = "2.2.5";

  repoName = "capnet-assist";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "09pl1ynrmqjj844np4ww2i18z7kgx5kmj5ggfp8lqmxgsny7g8m3";
  };

  passthru = {
    updateScript = nix-update-script {
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
    homepage = "https://github.com/elementary/capnet-assist";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
