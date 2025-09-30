{
  lib,
  stdenv,

  buildGoModule,
  fetchFromGitHub,
  makeDesktopItem,

  protobuf,
  protoc-gen-go,
  protorpc,

  cmake,
  copyDesktopItems,
  ninja,

  qt6Packages,

  sing-geoip,
  sing-geosite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "throne";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "throneproj";
    repo = "Throne";
    tag = finalAttrs.version;
    hash = "sha256-CN0zf3Zp6G++fzvmsEfyZVM3pN08CorsejR1Q4ooGXo=";
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

  cmakeFlags = [
    # makes sure the app uses the user's config directory to store it's non-static content
    # it's essentially the same as always setting the -appdata flag when running the program
    (lib.cmakeBool "NKR_PACKAGE" true)
  ];

  patches = [
    # if compiled with NKR_PACKAGE, Throne assumes geoip.db and geosite.db will be found in ~/.config/Throne
    # we already package those two files in nixpkgs
    # we can't place file at that location using our builder so we must change the search directory to be relative to the built executable
    ./search-for-geodata-in-install-location.patch

    # disable suid request as it cannot be applied to throne-core in nix store
    # and prompt users to use NixOS module instead. And use throne-core from PATH
    # to make use of security wrappers
    ./nixos-disable-setuid-request.patch
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 Throne -t "$out/share/throne/"
    install -Dm644 "$src/res/public/Throne.png" -t "$out/share/icons/hicolor/512x512/apps/"

    mkdir -p "$out/bin"
    ln -s "$out/share/throne/Throne" "$out/bin/"

    ln -s ${finalAttrs.passthru.core}/bin/Core "$out/share/throne/Core"

    # our patch makes Throne look for geodata files next to the executable
    ln -s ${sing-geoip}/share/sing-box/geoip.db "$out/share/throne/geoip.db"
    ln -s ${sing-geosite}/share/sing-box/geosite.db "$out/share/throne/geosite.db"

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
    vendorHash = "sha256-W6T/vqZgWDVz1WCxx2eArnP7bVm2D2+RM/cZSSY+Hbo=";

    nativeBuildInputs = [
      protobuf
      protoc-gen-go
      protorpc
    ];

    # taken from script/build_go.sh
    preBuild = ''
      pushd gen
      protoc -I . --go_out=. --protorpc_out=. libcore.proto
      popd
    '';

    # ldflags and tags are taken from script/build_go.sh
    ldflags = [
      "-w"
      "-s"
      "-X github.com/sagernet/sing-box/constant.Version=${finalAttrs.version}"
    ];

    tags = [
      "with_clash_api"
      "with_gvisor"
      "with_quic"
      "with_wireguard"
      "with_utls"
      "with_ech"
      "with_dhcp"
    ];
  };

  # this tricks nix-update into also updating the vendorHash of throne-core
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
