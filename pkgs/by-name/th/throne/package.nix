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
    url = "https://raw.githubusercontent.com/throneproj/routeprofiles/c637d0bb8a3707eb5e122c81753600d3e18a5969/srslist.h";
    hash = "sha256-Kf3TAGXi7Y0PhWjdTOZdPUMlimszWkcrQw9zv8pb76s=";
  },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "throne";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "throneproj";
    repo = "Throne";
    tag = finalAttrs.version;
    hash = "sha256-gtbGKyEOTq+1IP7v4ZhVVohGQFlDtP7NbbhyFD2rCnA=";
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
    vendorHash = "sha256-G0ev2my+sHQFYdmfkR2Zq3ujSeqi5fZ4BdrnUS8mfDE=";

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
      "with_naive_outbound"
      "with_purego" # prebuilt .a files inside cronet-go are annoying to fix
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
