{ lib
, stdenv
, fetchFromGitHub
, glib
, meson
, ninja
, python3Packages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-media-player-applet";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "zalesyc";
    repo = "budgie-media-player-applet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E4aD7/SJNvWe6B3iX8fUZeZj14+uxjn0s+30BhU0dxE=";
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
    substituteInPlace meson.build --replace-fail "/usr" "$out"
    substituteInPlace meson_post_install.py --replace-fail '"/", "usr"' "\"$out\""
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
    maintainers = lib.teams.budgie.members;
  };
})
