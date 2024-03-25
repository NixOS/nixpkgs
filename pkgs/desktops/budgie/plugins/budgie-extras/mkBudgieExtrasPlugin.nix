{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, budgie
, sound-theme-freedesktop
, util-linux
, vorbis-tools
, xdg-utils
, bash
, libnotify
, locale
, plank
, procps
, wmctrl
, xdotool
, gnome
, xorg
, glib
, intltool
, meson
, ninja
, pkg-config
, python3
, vala
}:

{
  # Name of the directory the plugin is located at.
  pluginName
  # Name of the plugin in the meson_options.txt file.
, mesonOptionName ? pluginName
  # Name of the plugin entrypoint, found under the "Module" key in the .plugin
  # file. Only used by Python plugins.
, moduleName ? pluginName
  # Is this a Python plugin?
, isPython ? false
, ...
} @ args:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-${pluginName}";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "UbuntuBudgie";
    repo = "budgie-extras";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-juPUs5qtY0Sqzh+AxuuWwJL34mL4t/bTbTFmfNg2JrY=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      sound_theme_freedesktop = sound-theme-freedesktop;
      util_linux = util-linux;
      vorbis_tools = vorbis-tools;
      xdg_utils = xdg-utils;
      inherit bash libnotify locale procps wmctrl xdotool;
      inherit (gnome) zenity;
      inherit (xorg) xrandr xinput xprop;
    })
  ];

  prePatch = ''
    substitute ${./fix-out-path.patch} fix-out-path.patch --subst-var-by out $out
    patches="$patches $PWD/fix-out-path.patch"
  '';

  nativeBuildInputs = [
    glib # glib-compile-schemas
    intltool
    meson
    ninja
    pkg-config
    python3
    # This is required by the top-level meson.build, even if the plugin is written in Python.
    vala
  ]
  ++ lib.optional isPython python3.pkgs.wrapPython
  ++ (args.nativeBuildInputs or [ ]);

  strictDeps = true;

  postPatch = ''
    substituteInPlace budgie-${pluginName}/meson.build --replace "/usr" "$out"
  '' + (args.postPatch or "");

  mesonFlags = [
    "-Dbuild-recommended=false"
    "-Dwith-default-schema=false"
    "-Dbuild-${mesonOptionName}=true"
  ] ++ (args.mesonFlags or [ ]);

  postFixup = lib.optionalString isPython ''
    buildPythonPath "$out $pythonPath"
    patchPythonScript "$out/lib/budgie-desktop/plugins/budgie-${pluginName}/${moduleName}.py";
  '' + (args.postFixup or "");

  meta = {
    homepage = "https://github.com/UbuntuBudgie/budgie-extras";
    changelog = "https://github.com/UbuntuBudgie/budgie-extras/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl3Plus;
    maintainers = lib.teams.budgie.members;
    platforms = lib.platforms.linux;
  } // (args.meta or { });
} // builtins.removeAttrs args [
  "pluginName"
  "mesonOptionName"
  "nativeBuildInputs"
  "mesonFlags"
  "postPatch"
  "postFixup"
  "meta"
])
