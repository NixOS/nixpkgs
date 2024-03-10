{ lib
, stdenv
, fetchFromGitHub
, glib
, meson
, ninja
, python3Packages
}:

stdenv.mkDerivation {
  pname = "budgie-media-player-applet";
  version = "1.0.0-unstable-2023-12-31";

  src = fetchFromGitHub {
    owner = "zalesyc";
    repo = "budgie-media-player-applet";
    rev = "24500be1e0a1f92968df80f8befdf896723ba8ee";
    hash = "sha256-jQgkE6vv8PIcB0MJgfsQvzMRkkMU51Gqefoa2G6YJCw=";
  };

  nativeBuildInputs = [
    glib # glib-compile-schemas
    meson
    ninja
    python3Packages.wrapPython
  ];

  pythonPath = with python3Packages; [
    pillow
    requests
  ];

  postPatch = ''
    substituteInPlace meson.build --replace "/usr" "$out"
    substituteInPlace meson_post_install.py --replace '"/", "usr"' "\"$out\""
  '';

  postFixup = ''
    buildPythonPath "$out $pythonPath"
    patchPythonScript "$out/lib/budgie-desktop/plugins/budgie-media-player-applet/applet.py"
  '';

  meta = {
    description = "Media Control Applet for the Budgie Panel";
    homepage = "https://github.com/zalesyc/budgie-media-player-applet";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
}
