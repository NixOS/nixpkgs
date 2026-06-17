{
  lib,
  stdenv,

  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  makeDesktopItem,

  protobuf,
  protoc-gen-go,
  protorpc,

  cmake,
  copyDesktopItems,
  ninja,

  qt6Packages,

  # override if you want to have more up-to-date rulesets
  throne-srslist ? fetchurl {
    url = "https://raw.githubusercontent.com/throneproj/routeprofiles/0fca735ff2759422c407ac04fac819aef2fc88f9/srslist.h";
    hash = "sha256-G2WUStxFtN0fbZm/KoD9ldUvkMWf9cDA+9fvYt8dcqo=";
  },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "throne";
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "throneproj";
    repo = "Throne";
    # the release CI job was triggered on the xhttp branch (https://github.com/throneproj/Throne/actions/runs/20588046213),
    # but the 1.0.13 tag was wrongly created on the dev branch
    # we'll use the revision that was used for the job as well
    rev = "3b737ec8cf29e03e4b7d5a09b1f502bdb8ef52e2";
    hash = "sha256-OVgmhiKL4BaFYBeUqIX3LRNa54zq5oYyNMUYwKNvo1A=";
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

  cmakeFlags = [
    # makes sure the app uses the user's config directory to store it's non-static content
    # it's essentially the same as always setting the -appdata flag when running the program
    (lib.cmakeBool "NKR_PACKAGE" true)
  ];

  patches = [
    # disable suid request as it cannot be applied to throne-core in nix store
    # and prompt users to use NixOS module instead. And use throne-core from PATH
    # to make use of security wrappers
    ./nixos-disable-setuid-request.patch
  ];

  preBuild = ''
    ln -s ${throne-srslist} ./srslist.h
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 Throne -t "$out/share/throne/"
    install -Dm644 "$src/res/public/Throne.png" -t "$out/share/icons/hicolor/512x512/apps/"

    mkdir -p "$out/bin"
    ln -s "$out/share/throne/Throne" "$out/bin/"

    ln -s ${finalAttrs.passthru.core}/bin/Core "$out/share/throne/Core"

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
    vendorHash = "sha256-cPo/2bUXEF9jomr0Pnty7ZutAaC0TFG397FSIqefrjw=";

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

      VERSION_SINGBOX=$(go list -m -f '{{.Version}}' github.com/sagernet/sing-box)
      ldflags+=("-X 'github.com/sagernet/sing-box/constant.Version=$VERSION_SINGBOX'")
    '';

    # ldflags and tags are taken from script/build_go.sh
    ldflags = [
      "-w"
      "-s"
    ];

    tags = [
      "with_clash_api"
      "with_gvisor"
      "with_quic"
      "with_wireguard"
      "with_utls"
      "with_dhcp"
      "with_tailscale"
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
