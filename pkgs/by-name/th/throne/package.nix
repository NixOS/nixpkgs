{
  lib,
  stdenv,

  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  makeDesktopItem,
  nix-update-script,

  protobuf,
  protoc-gen-go,
  protoc-gen-go-grpc,

  cmake,
  copyDesktopItems,
  ninja,

  qt6Packages,

  # To get the latest revision go to the rule-set branch and get the revision of the last commit
  # Link: https://github.com/throneproj/routeprofiles/tree/rule-set
  throne-srslist-info ? {
    rev = "eb0476e5362638b33254b3793958026bd47eef9f";
    hash = "sha256-qqeD56cOjn3qxu/Fi6zJ4Sn5RRS+RpgMQKL2s+eRiLM=";
  },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "throne";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "throneproj";
    repo = "Throne";
    tag = finalAttrs.version;
    hash = "sha256-qzQWUG4pAnNAtF/FmboNvj/XULCn+ww2ImG/d5DbR5w=";
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

    # sets the Exec field of the auto-run and the scheme-handler .desktop files to use the Throne binary from PATH
    ./fix-desktop-exec.patch
  ];

  preBuild =
    let
      srslist = fetchurl {
        name = "throne-srslist-${throne-srslist-info.rev}.h";
        url = "https://raw.githubusercontent.com/throneproj/routeprofiles/${throne-srslist-info.rev}/srslist.h";
        hash = throne-srslist-info.hash;
      };
    in
    ''
      ln -s ${srslist} ./srslist.h
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
    modRoot = "./core/server";

    patches = [
      # also check cap_net_admin so we don't have to set suid
      ./core-also-check-capabilities.patch

      # disable a security check, which hopefully is not too bad
      ./dont-check-parent.patch
    ];

    vendorHash = "sha256-1yVQspaI0wLLJ6IrGABTpF3YSL3uhJTbapo1A0hAPZo=";

    nativeBuildInputs = [
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
    ];

    preBuild = ''
      # run only if we're not in the FOD fetcher
      if [ -d vendor ]; then
        install -Dm755 vendor/github.com/sagernet/cronet-go/lib/"$GOOS"_"$GOARCH"/libcronet.so -t "$out/lib/"

        substituteInPlace vendor/github.com/sagernet/cronet-go/internal/cronet/loader_unix.go \
          --replace-fail "path = findLibrary()" "path = \"$out/lib/libcronet.so\""

        # taken from script/build_go.sh
        pushd gen
        protoc -I . --go_out=. --go-grpc_out=. libcore.proto
        popd

        VERSION_SINGBOX=$(go list -m -f '{{.Version}}' github.com/sagernet/sing-box)
        ldflags+=("-X 'github.com/sagernet/sing-box/constant.Version=$VERSION_SINGBOX'")
      fi
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
      "with_purego" # use prebuilt .so instead of prebuilt .a files for cronet-go
    ];
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "core"
    ];
  };

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
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # libcronet.so used by throne.core
    ];
  };
})
