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
    rev = "1aa995b5fc30c26b931a61171aea2ab49c3d1711";
    hash = "sha256-jKYUjgxpE1zwcVv+9Fdj8H1QnPZpTzmzVsMfOMOKGFw=";
  },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "throne";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "throneproj";
    repo = "Throne";
    tag = finalAttrs.version;
    hash = "sha256-G1i8nFMabkg7qUbqYq/GYXsREXRcSXtDSO+RgiuulIE=";
  };

  # NKR_ELEVATION_HINT contains spaces
  __structuredAttrs = true;
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

  cmakeFlags = [
    # use a writable config dir
    (lib.cmakeBool "NKR_PACKAGE" true)
    # use ThroneCore from PATH first to make use of security wrappers
    (lib.cmakeBool "NKR_CORE_IN_PATH" true)
    # the Exec field of the auto-run and the scheme-handler .desktop files
    (lib.cmakeFeature "NKR_DESKTOP_EXEC" "Throne")
    # suid cannot be set on ThroneCore in the Nix store, so point users to the NixOS module instead
    (lib.cmakeFeature "NKR_ELEVATION_HINT" "On NixOS, use programs.throne with tunMode.enable.")
  ];

  env.INPUT_VERSION = finalAttrs.version;

  # suppress errors in 3rdparty/simple-protobuf
  env.NIX_CFLAGS_COMPILE = "-Wno-error=maybe-uninitialized";

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

    makeQtWrapper "$out/share/throne/Throne" "$out/bin/Throne"

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
    modRoot = "./core";

    # skip cmd/schemagen, a development tool
    subPackages = [ "." ];

    # the main package has no tests, checkPhase would only rebuild all deps without -trimpath
    doCheck = false;

    vendorHash = "sha256-L189eeaYDdDKGJYT5vr412YpTgHptVfC4jpNSjNcyuk=";

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
      "with_openvpn"
      "with_openconnect"
      "badlinkname"
      "tfogo_checklinkname0"
      "with_naive_outbound"
      "with_purego" # use prebuilt .so instead of prebuilt .a files for cronet-go
      "noparentcheck" # ThroneCore and the GUI live in different store paths
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
    changelog = "https://github.com/throneproj/Throne/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "Throne";
    maintainers = with lib.maintainers; [
      tomasajt
      aleksana
      Mahdi-zarei
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # libcronet.so used by throne.core
    ];
  };
})
