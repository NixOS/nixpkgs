{
  stdenv,
  lib,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  fetchpatch,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  libxml2,
  libpeas,
  glib,
  gtk3,
  gtksourceview4,
  gspell,
  xapp,
  xapp-symbolic-icons,
  pkg-config,
  python3,
<<<<<<< HEAD
  python3Packages,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meson,
  ninja,
  versionCheckHook,
  wrapGAppsHook3,
  intltool,
  itstool,
}:

stdenv.mkDerivation rec {
  pname = "xed-editor";
<<<<<<< HEAD
  version = "3.8.7";
=======
  version = "3.8.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xed";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Vl2yf4PlREvyAY/lRP+nB47GEuuyYeLnBARKhDEfG4M=";
=======
    hash = "sha256-iPD9SawHA0bwnZvC+IyMq9cFE1YOYLISehUJjTXiqGw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [
    # We patch gobject-introspection and meson to store absolute paths to libraries in typelibs
    # but that requires the install_dir is an absolute path.
    ./correct-gir-lib-path.patch
<<<<<<< HEAD
=======

    # Switch to girepository-2.0
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/xed/raw/6c1a775158f166a3bc5759a6c7bd57bab8f2771a/f/libpeas_libgirepository2.patch";
      hash = "sha256-wGbmS33YHMiSfd3S0fQRhL6tT536kto69MSgPkY2QIs=";
    })
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    intltool
    itstool
    ninja
    python3
    versionCheckHook
    wrapGAppsHook3
  ];

  buildInputs = [
    libxml2
    glib
    gtk3
    gtksourceview4
    libpeas
    gspell
<<<<<<< HEAD
    python3Packages.pygobject3
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    xapp
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}"
    )
  '';

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/xed";

<<<<<<< HEAD
  meta = {
    description = "Light weight text editor from Linux Mint";
    homepage = "https://github.com/linuxmint/xed";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Light weight text editor from Linux Mint";
    homepage = "https://github.com/linuxmint/xed";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      tu-maurice
      bobby285271
    ];
    mainProgram = "xed";
  };
}
