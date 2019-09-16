{ stdenv
, fetchFromGitHub
, pantheon
, pkgconfig
, meson
, ninja
, vala
, python3
, desktop-file-utils
, gtk3
, granite
, libgee
, libcanberra
, elementary-icon-theme
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-screenshot-tool"; # This will be renamed to "screenshot" soon. See -> https://github.com/elementary/screenshot/pull/93
  version = "1.6.2";

  repoName = "screenshot";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1z61j96jk9zjr3bn5hgsp25m4v8h1rqwxm0kg8c34bvl06f13v8q";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      inherit repoName;
      attrPath = pname;
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
    elementary-icon-theme
    granite
    gtk3
    libcanberra
    libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Screenshot tool designed for elementary OS";
    homepage = https://github.com/elementary/screenshot;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
