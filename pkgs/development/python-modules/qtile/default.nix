{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  fetchpatch,
  cairocffi,
  dbus-fast,
  aiohttp,
  cairo,
  cffi,
=======
  cairocffi,
  dbus-fast,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  glib,
  iwlib,
  libcst,
  libdrm,
  libinput,
  libxkbcommon,
  mpd2,
  pango,
  pixman,
  pkg-config,
  psutil,
  pulsectl-asyncio,
  pygobject3,
  pytz,
<<<<<<< HEAD
=======
  pywayland,
  pywlroots,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyxdg,
  setuptools,
  setuptools-scm,
  wayland,
<<<<<<< HEAD
  wayland-protocols,
  wayland-scanner,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  wlroots,
  xcbutilcursor,
  xcbutilwm,
  xcffib,
<<<<<<< HEAD
=======
  xkbcommon,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nixosTests,
  extraPackages ? [ ],
}:

buildPythonPackage rec {
  pname = "qtile";
<<<<<<< HEAD
  version = "0.34.1";
=======
  version = "0.33.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qtile";
    repo = "qtile";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-PPyI+IGvHBQusVmU3D26VjYjLaa9+94KUqNwbQSzeaI=";
  };

  patches = [
    # The patch below makes upstream's build script search for wayland-scanner
    # simply in $PATH, and not via `pkg-config`. This allows us to put
    # wayland-scanner in nativeBuildInputs and keep using `strictDeps`. See:
    #
    # https://github.com/qtile/qtile/pull/5726
    #
    # Upstream has merged the PR directly - without creating a merge commit, so
    # using a range is required.
    (fetchpatch {
      name = "qtile-PR5726-wayland-scanner-pkg-config.patch";
      url = "https://github.com/qtile/qtile/compare/f0243abee5e6b94ef92b24e99d09037a4f40272b..553845bd17f38a6d1dee763a23c1b015df894794.patch";
      hash = "sha256-hRArLC4nQMAbT//QhQeAUL1o7OCV0zvrlJztDavI0K0=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];
  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  env = {
    "QTILE_CAIRO_PATH" = "${lib.getDev cairo}/include/cairo";
    "QTILE_PIXMAN_PATH" = "${lib.getDev pixman}/include/pixman-1";
    "QTILE_LIBDRM_PATH" = "${lib.getDev libdrm}/include/libdrm";
    "QTILE_WLROOTS_PATH" =
      "${lib.getDev wlroots}/include/wlroots-${lib.versions.majorMinor wlroots.version}";
  };

  pypaBuildFlags = [
    "--config-setting=backend=wayland"
    "--config-setting=GOBJECT=${lib.getLib glib}/lib/libgobject-2.0.so"
    "--config-setting=PANGO=${lib.getLib pango}/lib/libpango-1.0.so"
    "--config-setting=PANGOCAIRO=${lib.getLib pango}/lib/libpangocairo-1.0.so"
    "--config-setting=XCBCURSOR=${lib.getLib xcbutilcursor}/lib/libxcb-cursor.so"
=======
    hash = "sha256-npteZR48xN3G5gDsHt8c67zzc8Tom1YxnxbnDuKZHVg=";
  };

  patches = [
    ./fix-restart.patch # https://github.com/NixOS/nixpkgs/issues/139568
  ];

  postPatch = ''
    substituteInPlace libqtile/pangocffi.py \
      --replace-fail libgobject-2.0.so.0 ${glib.out}/lib/libgobject-2.0.so.0 \
      --replace-fail libpangocairo-1.0.so.0 ${pango.out}/lib/libpangocairo-1.0.so.0 \
      --replace-fail libpango-1.0.so.0 ${pango.out}/lib/libpango-1.0.so.0
    substituteInPlace libqtile/backend/x11/xcursors.py \
      --replace-fail libxcb-cursor.so.0 ${xcbutilcursor.out}/lib/libxcb-cursor.so.0
    substituteInPlace libqtile/backend/wayland/cffi/build.py \
        --replace-fail /usr/include/pixman-1 ${lib.getDev pixman}/include \
        --replace-fail /usr/include/libdrm ${lib.getDev libdrm}/include/libdrm
  '';

  build-system = [
    setuptools
    setuptools-scm
    pkg-config
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  dependencies = extraPackages ++ [
    (cairocffi.override { withXcffib = true; })
    dbus-fast
    iwlib
    libcst
    mpd2
    psutil
    pulsectl-asyncio
    pygobject3
    pytz
<<<<<<< HEAD
    pyxdg
    xcffib
  ];

  buildInputs = [
    cairo
=======
    pywayland
    pywlroots
    pyxdg
    xcffib
    xkbcommon
  ];

  buildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    libinput
    libxkbcommon
    wayland
    wlroots
    xcbutilwm
  ];

<<<<<<< HEAD
  propagatedBuildInputs = [
    wayland-protocols
    cffi
    xcffib
    aiohttp
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doCheck = false;
  passthru = {
    tests.qtile = nixosTests.qtile;
    providedSessions = [ "qtile" ];
  };

  postInstall = ''
    install resources/qtile.desktop -Dt $out/share/xsessions
    install resources/qtile-wayland.desktop -Dt $out/share/wayland-sessions
  '';

<<<<<<< HEAD
  meta = {
    homepage = "http://www.qtile.org/";
    license = lib.licenses.mit;
    description = "Small, flexible, scriptable tiling window manager written in Python";
    mainProgram = "qtile";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      arjan-s
      sigmanificient
      doronbehar
=======
  meta = with lib; {
    homepage = "http://www.qtile.org/";
    license = licenses.mit;
    description = "Small, flexible, scriptable tiling window manager written in Python";
    mainProgram = "qtile";
    platforms = platforms.linux;
    maintainers = with maintainers; [
      arjan-s
      sigmanificient
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
  };
}
