{
  lib,
  stdenv,
  fetchFromGitea,
  alsa-lib,
  bison,
  fcft,
  flex,
  json_c,
  libmpdclient,
  libyaml,
  meson,
  ninja,
  pipewire,
  pixman,
  pkg-config,
  pulseaudio,
  scdoc,
  tllist,
  udev,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xcbutil,
  xcbutilcursor,
  xcbutilerrors,
  xcbutilwm,
  waylandSupport ? true,
  x11Support ? true,
}:

assert (x11Support || waylandSupport);
stdenv.mkDerivation (finalAttrs: {
  pname = "yambar";
  version = "1.11.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "yambar";
    rev = finalAttrs.version;
    hash = "sha256-QCwwMpBYuMWYqxE2ugPFpG/QtZDW7VsSBYs5EqKYejA=";
  };

  outputs = [
    "out"
    "man"
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    bison
    flex
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs =
    [
      alsa-lib
      fcft
      json_c
      libmpdclient
      libyaml
      pipewire
      pixman
      pulseaudio
      tllist
      udev
    ]
    ++ lib.optionals (waylandSupport) [
      wayland
      wayland-protocols
    ]
    ++ lib.optionals (x11Support) [
      xcbutil
      xcbutilcursor
      xcbutilerrors
      xcbutilwm
    ];

  strictDeps = true;

  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonBool "werror" false)
    (lib.mesonEnable "backend-x11" x11Support)
    (lib.mesonEnable "backend-wayland" waylandSupport)
  ];

  meta = {
    homepage = "https://codeberg.org/dnkl/yambar";
    description = "Modular status panel for X11 and Wayland";
    longDescription = ''
      yambar is a lightweight and configurable status panel (bar, for short) for
      X11 and Wayland, that goes to great lengths to be both CPU and battery
      efficient - polling is only done when absolutely necessary.

      It has a number of modules that provide information in the form of tags.
      For example, the clock module has a date tag that contains the current
      date.

      The modules do not know how to present the information though. This is
      instead done by particles. And the user, you, decides which particles (and
      thus how to present the data) to use.

      Furthermore, each particle can have a decoration - a background color or a
      graphical underline, for example.

      There is no support for images or icons. use an icon font (e.g. Font
      Awesome, or Material Icons) if you want a graphical representation.

      There are a number of modules and particles builtin. More can be added as
      plugins. You can even write your own!

      To summarize: a bar displays information provided by modules, using
      particles and decorations. How is configured by you.
    '';
    changelog = "https://codeberg.org/dnkl/yambar/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
    mainProgram = "yambar";
  };
})
