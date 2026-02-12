{
  lib,
  stdenv,

  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  makeDesktopItem,

  protobuf,
  protoc-gen-go,
  protoc-gen-go-grpc,

  cmake,
  copyDesktopItems,
  ninja,

  qt6Packages,

  # override if you want to have more up-to-date rulesets
  throne-srslist ? fetchurl {
    url = "https://raw.githubusercontent.com/throneproj/routeprofiles/05793e2da7ca10a7acb2494f60a27ac5f7ec924c/srslist.h";
    hash = "sha256-NHer5Vy1zBL9yJlVDLVFNRG4ITzb2GTjmt718KsSrGw=";
  },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "throne";
  version = "1.1.1-unstable-2026-03-28";

  src = fetchFromGitHub {
    owner = "throneproj";
    repo = "Throne";
    rev = "f53bb73790782a9a9b7bfeb30c8d6e6bcc2b05f0";
    hash = "sha256-hEjbzS0JV5OA0c9kWTFGc5kv04qzobN0TFBjMJZ1ohc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.qtbase
    qt6Packages.qttools
  ];

  env.INPUT_VERSION = finalAttrs.version;

  # suppress errors in 3rdparty/simple-protobuf
  env.NIX_CFLAGS_COMPILE = "-Wno-error=maybe-uninitialized";

  patches = [
    # disable suid request as it cannot be applied to ThroneCore in nix store
    # and prompt users to use NixOS module instead. And use ThroneCore from PATH
    # to make use of security wrappers
    ./nixos-disable-setuid-request.patch

    # sets the Exec field of the auto-run .desktop file to use the Throne binary from PATH
    ./fix-autorun-desktop-exec.patch
  ];

  preBuild = ''
    ln -s ${throne-srslist} ./srslist.h
  '';

  # we'll wrap manually
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 Throne -t "$out/share/throne/"
    install -Dm644 "$src/res/public/Throne.png" -t "$out/share/icons/hicolor/512x512/apps/"

    makeQtWrapper "$out/share/throne/Throne" "$out/bin/Throne" \
      --append-flag "-appdata" # use writable config dir

    ln -s ${finalAttrs.passthru.core}/bin/ThroneCore "$out/share/throne/ThroneCore"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "throne";
      desktopName = "Throne";
      exec = "Throne";
      icon = "Throne";
      comment = finalAttrs.meta.description;
      terminal = false;
      categories = [ "Network" ];
    })
  ];

  passthru.core = buildGoModule {
    pname = "throne-core";
    inherit (finalAttrs) version src;
    sourceRoot = "${finalAttrs.src.name}/core/server";

    patches = [
      # also check cap_net_admin so we don't have to set suid
      ./core-also-check-capabilities.patch
    ];

    proxyVendor = true;
    vendorHash = "sha256-HNd0HI4JRPZiiSxDzOKgyAOW7tzZPCTPvOC5t+3yhoQ=";

    nativeBuildInputs = [
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
    ];

    # taken from script/build_go.sh
    preBuild = ''
      pushd gen
      protoc -I . --go_out=. --go-grpc_out=. libcore.proto
      popd

      VERSION_SINGBOX=$(go list -m -f '{{.Version}}' github.com/sagernet/sing-box)
      ldflags+=("-X 'github.com/sagernet/sing-box/constant.Version=$VERSION_SINGBOX'")
    '';

    # ldflags and tags are taken from script/build_go.sh
    ldflags = [
      "-w"
      "-s"
      "-X"
      "internal/godebug.defaultGODEBUG=multipathtcp=0"
      "-checklinkname=0"
    ];

    tags = [
      "with_clash_api"
      "with_gvisor"
      "with_quic"
      "with_wireguard"
      "with_utls"
      "with_dhcp"
      "with_tailscale"
      "badlinkname"
      "tfogo_checklinkname"
    ];
  };

  # this tricks nix-update into also updating the vendorHash of passthru.core
  passthru.goModules = finalAttrs.passthru.core.goModules;

  meta = {
    description = "Qt based cross-platform GUI proxy configuration manager";
    homepage = "https://github.com/throneproj/Throne";
    license = lib.licenses.gpl3Plus;
    mainProgram = "Throne";
    maintainers = with lib.maintainers; [
      tomasajt
      aleksana
    ];
    platforms = lib.platforms.linux;
  };
})
