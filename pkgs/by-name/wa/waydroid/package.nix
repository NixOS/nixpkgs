{
  lib,
  fetchFromGitHub,
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
  nftables,
  util-linux,
  wrapGAppsHook3,
  wl-clipboard,
  runtimeShell,
  nix-update-script,
  withNftables ? false,
}:

python3Packages.buildPythonApplication rec {
  pname = "waydroid";
  version = "1.6.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "waydroid";
    repo = "waydroid";
    tag = version;
    hash = "sha256-w0cnFTpPNxAQDCGkbyVg9k5ccw7Ym3cLhSEw2Uv+RxU=";
  };

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
    "PREFIX=${placeholder "out"}"
    "USE_SYSTEMD=0"
    "SYSCONFDIR=${placeholder "out"}/etc"
  ]
  ++ (lib.optional withNftables "USE_NFTABLES=1");

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")

    patchShebangs --host $out/lib/waydroid/data/scripts
    wrapProgram $out/lib/waydroid/data/scripts/waydroid-net.sh \
      --prefix PATH ":" ${
        lib.makeBinPath [
          dnsmasq
          getent
          iproute2
          (if withNftables then nftables else iptables)
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

    substituteInPlace $out/lib/waydroid/tools/helpers/run.py $out/lib/waydroid/tools/helpers/lxc.py \
      --replace-fail '"sh"' '"${runtimeShell}"'
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
