{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libx11,
  libxrandr,
  writeText,
  # customization
  config,
  conf ? config.twmx.conf or null,
  patches ? config.twmx.patches or [ ],
  # update script dependencies
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "twmx";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "arcbaseproject";
    repo = "twmx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2KEa0I3PK0ECufMk//zD5r8C7S6rZa9L07dKI+zCKO0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    libxrandr
  ];

  # Allow users set their own list of patches
  inherit patches;

  # Allow users to set the config.def.h file containing the configuration
  postPatch =
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf then conf else writeText "config.def.h" conf;
    in
    lib.optionalString (conf != null) "cp ${configFile} config.def.h";

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
    "PREFIX=${placeholder "out"}"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://github.com/arcbaseproject/twmx";
    description = "Small, fast tiling window manager for X11, grown out of TinyWM";
    longDescription = ''
      twmx is a tiling window manager for X11 in a single C file, configured
      at compile time through config.h like dwm. It provides master/stack and
      monocle layouts with gaps, floating and fullscreen windows, nine
      workspaces with one shown per monitor, XRandR multi-monitor support and
      the common EWMH/ICCCM hints, including struts for external bars.
    '';
    license = lib.licenses.unlicense;
    platforms = lib.platforms.linux;
    mainProgram = "twmx";
    maintainers = with lib.maintainers; [ arcbaseproject ];
  };
})
