{ stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkgconfig
, meson
, ninja
, vala
, desktop-file-utils
, libxml2
, gtk3
, python3
, granite
, libgee
, elementary-icon-theme
, appstream
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-calculator";
  version = "1.5.5";

  repoName = "calculator";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1csxsr2c8qvl97xz9ahwn91z095nzgr0i1mbcb1spljll2sr9lkj";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

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
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/elementary/calculator";
    description = "Calculator app designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
