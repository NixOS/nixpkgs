# to prevent bloating this package, please choose what integration you want
# to use manually, like this:
#   vala-panel-appmenu.override { enableMate = true; }
# the package compiles very quickly, so there is no sense to have every
# single combination to be build by hydra
{
  lib,
  budgie-desktop,
  fetchFromGitLab,
  glib,
  gobject-introspection,
  gtk2,
  jdk,
  libdbusmenu,
  libwnck,
  libxkbcommon,
  mate,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
  stripJavaArchivesHook,
  vala,
  vala-panel-appmenu,
  wrapGAppsHook3,
  xfce,

  enableXfce ? false,
  enableBudgie ? false,
  enableValapanel ? false, # NOTE: requires https://github.com/rilian-la-te/vala-panel which is not packaged
  enableMate ? false,
  enableJayatana ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vala-panel-appmenu";
  version = "24.05";

  src = fetchFromGitLab {
    owner = "vala-panel-project";
    repo = "vala-panel-appmenu";
    tag = finalAttrs.version;
    hash = "sha256-8GWauw7r3zKhvGF2TNOI8GDVctUFDhtG/Vy1cNUpsVo=";
    fetchSubmodules = true;
  };

  patches = [
    # for some weird reason, upstream tries to install its content
    # into library files that it uses. this is not allowed on linux
    ./proper-install-dirs.patch
  ];

  nativeBuildInputs =
    [
      meson
      ninja

      glib
      gobject-introspection
      gtk2
      libwnck
      pkg-config
      vala
      wrapGAppsHook3
    ]
    ++ lib.optionals enableXfce [
      xfce.xfce4-panel
      xfce.xfconf
    ]
    ++ lib.optional enableBudgie budgie-desktop
    ++ lib.optional enableMate mate.mate-panel-with-applets
    ++ lib.optionals enableJayatana [
      jdk
      libdbusmenu
      libxkbcommon
      stripJavaArchivesHook
    ];

  mesonAutoFeatures = "auto";
  mesonFlags = [
    (lib.mesonEnable "xfce" enableXfce)
    (lib.mesonEnable "budgie" enableBudgie)
    (lib.mesonEnable "valapanel" enableValapanel)
    (lib.mesonEnable "mate" enableMate)
    (lib.mesonEnable "jayatana" enableJayatana)
    (lib.mesonEnable "appmenu-gtk-module" true)
  ];

  passthru = {
    updateScript = nix-update-script { };

    # this just generates all possible combinations for `enable*` flags
    tests =
      let
        combinations =
          n: items:
          if n == 0 then
            [ [ ] ]
          else
            builtins.concatMap (b: map (l: [ b ] ++ l) (combinations (n - 1) items)) items;
        allArgs = combinations 4 [
          true
          false
        ];
      in
      lib.listToAttrs (
        lib.forEach allArgs (args: {
          name = lib.foldl (acc: a: acc + lib.boolToString a + "-") "" args;
          value = vala-panel-appmenu.override {
            enableXfce = builtins.elemAt args 0;
            enableBudgie = builtins.elemAt args 1;
            enableValapanel = false;
            enableMate = builtins.elemAt args 2;
            enableJayatana = builtins.elemAt args 3;
          };
        })
      );
  };

  meta = {
    description = "Global Menu for Vala Panel/XFCE/Budgie/Mate";
    homepage = "https://gitlab.com/vala-panel-project/vala-panel-appmenu";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ perchun ];
    mainProgram = "vala-panel-appmenu";
    platforms = lib.platforms.linux;
    # needs https://github.com/rilian-la-te/vala-panel
    broken = enableValapanel;
  };
})
