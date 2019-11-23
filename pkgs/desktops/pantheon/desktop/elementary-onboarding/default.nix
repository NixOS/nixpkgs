{ stdenv
, fetchFromGitHub
, pantheon
, fetchpatch
, pkgconfig
, meson
, ninja
, vala
, python3
, gtk3
, glib
, granite
, libgee
, elementary-icon-theme
, elementary-gtk-theme
, gettext
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-onboarding";
  version = "1.0.1";

  repoName = "onboarding";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "025i9av4waqwp1gn8d6sjp8qdwg2j3jskxhmyf9qxbzwfc5msysg";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      inherit repoName;
      attrPath = pname;
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
    elementary-icon-theme
    granite
    gtk3
    elementary-gtk-theme
    libgee
    glib
  ];

  patches = [
    # Make sure we use our logo from /etc/os-release
    (fetchpatch {
      url = "https://github.com/elementary/onboarding/commit/03975bacb75741d3dd391a126217e415f43c6059.patch";
      sha256 = "1yw7dysav90abxnmkv86bc60dyl8nvi0sgaiz8v39cc2x00rqsg1";
    })
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Onboarding app for new users designed for elementary OS";
    homepage = https://github.com/elementary/onboarding;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
