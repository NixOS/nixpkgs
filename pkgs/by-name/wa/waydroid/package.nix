{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
  dnsmasq,
  gawk,
  getent,
  gobject-introspection,
  gtk3,
  kmod,
  lxc,
  iproute2,
  iptables,
  util-linux,
  wrapGAppsHook3,
  wl-clipboard,
  runtimeShell,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "waydroid";
  version = "1.5.4";
  format = "other";

  src = fetchFromGitHub {
    owner = "waydroid";
    repo = "waydroid";
    tag = version;
    hash = "sha256-K4uJ9MVmr5+7O1em1yUJXZj6H8bpfm2ZAE2uqgiyDBQ=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/waydroid/waydroid/commit/af296c90a788dde0b33813b12607cfab2fa65b98.patch";
      hash = "sha256-1vkEKk00dbBLbbBxZIhcoOYUP976SJlaWyzYSWBy0nU=";
      revert = true;
    })
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = with python3Packages; [
    dbus-python
    gbinder-python
    pyclip
    pygobject3
  ];

  dontUseSetuptoolsBuild = true;
  dontUsePipInstall = true;
  dontWrapPythonPrograms = true;
  dontWrapGApps = true;

  installFlags = [
    "PREFIX=$(out)"
    "USE_SYSTEMD=0"
    "SYSCONFDIR=$(out)/etc"
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")

    patchShebangs --host $out/lib/waydroid/data/scripts
    wrapProgram $out/lib/waydroid/data/scripts/waydroid-net.sh \
      --prefix PATH ":" ${
        lib.makeBinPath [
          dnsmasq
          getent
          iproute2
          iptables
        ]
      }

    wrapPythonProgramsIn $out/lib/waydroid/ "${
      lib.concatStringsSep " " (
        [
          "$out"
        ]
        ++ propagatedBuildInputs
        ++ [
          gawk
          kmod
          lxc
          util-linux
          wl-clipboard
        ]
      )
    }"

    substituteInPlace $out/lib/waydroid/tools/helpers/*.py \
      --replace '"sh"' '"${runtimeShell}"'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Container-based approach to boot a full Android system on a regular GNU/Linux system";
    mainProgram = "waydroid";
    homepage = "https://github.com/waydroid/waydroid";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
