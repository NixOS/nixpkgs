{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  pkg-config,
  cmake,
  gettext,
  cairo,
  pango,
  glib,
  imlib2,
  gtk3,
  libXinerama,
  libXrender,
  libXcomposite,
  libXdamage,
  libX11,
  libXrandr,
  librsvg,
  libpthreadstubs,
  libXdmcp,
  libstartup_notification,
  wrapGAppsHook3,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "tint2";
  version = "17.1.3";

  src = fetchFromGitLab {
    owner = "nick87720z";
    repo = "tint2";
    tag = version;
    hash = "sha256-9sEe/Gnj+FWLPbWBtfL1YlNNC12j7/KjQ40xdkaFJVQ=";
  };

  patches = [
    # Fix crashes with glib >= 2.76
    # https://patchespromptly.com/glib2/
    # https://gitlab.com/nick87720z/tint2/-/issues/4
    (fetchpatch {
      url = "https://gitlab.com/nick87720z/tint2/uploads/7de4501a4fa4fffa5ba8bb0fa3d19f78/glib.patch";
      hash = "sha256-K547KYlRkVl1s2THi3ZCRuM447EFJwTqUEBjKQnV8Sc=";
    })
    # https://gitlab.com/nick87720z/tint2/-/merge_requests/4
    ./fix-cmake-version.patch
  ];

  # Fix build with gcc14
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-Wno-error=incompatible-pointer-types";

  nativeBuildInputs = [
    pkg-config
    cmake
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    pango
    glib
    imlib2
    gtk3
    libXinerama
    libXrender
    libXcomposite
    libXdamage
    libX11
    libXrandr
    librsvg
    libpthreadstubs
    libXdmcp
    libstartup_notification
  ];

  cmakeFlags = [
    "-Ddocdir=share/doc/${pname}"
  ];

  postPatch = ''
    # Add missing dependency on libm
    # https://gitlab.com/nick87720z/tint2/-/merge_requests/3
    substituteInPlace src/tint2conf/CMakeLists.txt \
      --replace-fail "RSVG_LIBRARIES} )" "RSVG_LIBRARIES} m)"

    substituteInPlace src/launcher/apps-common.c src/launcher/icon-theme-common.c \
      --replace-fail /usr/share/ /run/current-system/sw/share/
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    mainProgram = "tint2";
    homepage = "https://gitlab.com/nick87720z/tint2";
    description = "Simple panel/taskbar unintrusive and light (memory, cpu, aestetic)";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
  };
}
