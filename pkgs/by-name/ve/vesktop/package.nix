{ lib
, stdenv
, stdenvNoCC
, fetchFromGitHub
, substituteAll
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, vencord
, electron
, pipewire
, libicns
, jq
, moreutils
, nodePackages
, esbuild
, buildGoModule
}:
stdenv.mkDerivation rec {
  pname = "vesktop";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "Vencord";
    repo = "Vesktop";
    rev = "v${version}";
    sha256 = "sha256-Njs3tACxUyRolYUtS/q2lITIQnUBFXVXWZEfQ66HpPM=";
  };

  pnpm-deps = stdenvNoCC.mkDerivation {
    pname = "${pname}-pnpm-deps";
    inherit src version patches ELECTRON_SKIP_BINARY_DOWNLOAD;

    nativeBuildInputs = [
      jq
      moreutils
      nodePackages.pnpm
    ];

    # https://github.com/NixOS/nixpkgs/blob/763e59ffedb5c25774387bf99bc725df5df82d10/pkgs/applications/misc/pot/default.nix#L56
    installPhase = ''
      export HOME=$(mktemp -d)

      pnpm config set store-dir $out
      pnpm install --frozen-lockfile --ignore-script

      rm -rf $out/v3/tmp
      for f in $(find $out -name "*.json"); do
        sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
        jq --sort-keys . $f | sponge $f
      done
    '';

    dontFixup = true;
    outputHashMode = "recursive";
    outputHash = "sha256-vInaSLGahRUgvwAeUcI+oV84L+tgNRCmfFpE0aUD4X4=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    nodePackages.pnpm
    nodePackages.nodejs
    makeWrapper
  ];

  patches = [
    (substituteAll { inherit vencord; src = ./use_system_vencord.patch; })
  ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  preBuild =
    let
      arch = if stdenv.isx86_64 then "x64" else
      if stdenv.isi686 then "ia32" else
      if stdenv.isAarch64 then "arm64" else
      abort "vesktop: could not determine arch";
      makePackageJson = version: builtins.toFile "package.json" (builtins.toJSON {
        inherit version;
        name = "@esbuild/linux-${arch}";
      });
      esbuildVesktop = lib.getExe (esbuild.override {
        buildGoModule = args: buildGoModule (args // rec {
          version = "0.18.17";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            rev = "v${version}";
            hash = "sha256-OnAOomKVUIBTEgHywDSSx+ggqUl/vn/R0JdjOb3lUho=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        });
      });
      esbuildTsx = lib.getExe (esbuild.override {
        buildGoModule = args: buildGoModule (args // rec {
          version = "0.17.19";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            rev = "v${version}";
            hash = "sha256-PLC7OJLSOiDq4OjvrdfCawZPfbfuZix4Waopzrj8qsU=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        });
      });
    in
    ''
      export HOME=$(mktemp -d)
      export STORE_PATH=$(mktemp -d)

      cp -r ${pnpm-deps}/* "$STORE_PATH"
      chmod -R +w "$STORE_PATH"

      pnpm config set store-dir "$STORE_PATH"
      pnpm install --offline --frozen-lockfile --ignore-script

      # there are two copies of esbuild with different versions in the dependency tree.
      # `ESBUILD_BINARY_PATH` will affect both of them, so it doesn't work.
      # so I'm constructing fake esbuild native packages in their expected places.
      mkdir -p node_modules/@esbuild-kit/core-utils/node_modules/esbuild/node_modules/@esbuild/linux-${arch}/bin
      cp ${makePackageJson "0.17.19"} node_modules/@esbuild-kit/core-utils/node_modules/esbuild/node_modules/@esbuild/linux-${arch}/package.json
      cp ${esbuildTsx} node_modules/@esbuild-kit/core-utils/node_modules/esbuild/node_modules/@esbuild/linux-${arch}/bin/esbuild

      mkdir -p node_modules/esbuild/node_modules/@esbuild/linux-${arch}/bin
      cp ${makePackageJson "0.18.17"} node_modules/esbuild/node_modules/@esbuild/linux-${arch}/package.json
      cp ${esbuildVesktop} node_modules/esbuild/node_modules/@esbuild/linux-${arch}/bin/esbuild

      patchShebangs node_modules/{*,.*}
    '';

  postBuild = ''
    pnpm build
    # using `pnpm exec` here apparently makes it ignore ELECTRON_SKIP_BINARY_DOWNLOAD
    ./node_modules/.bin/electron-builder \
      --dir \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version}
  '';

  # this is consistent with other nixpkgs electron packages and upstream, as far as I am aware
  # yes, upstream really packages it as "vesktop" but uses "vencorddesktop" file names
  installPhase =
    let
      libPath = lib.makeLibraryPath [ pipewire ];
    in
    ''
      runHook preInstall

      mkdir -p $out/opt/Vesktop/resources
      cp dist/linux-unpacked/resources/app.asar $out/opt/Vesktop/resources

      pushd build
      ${libicns}/bin/icns2png -x icon.icns
      for file in icon_*x32.png; do
        file_suffix=''${file//icon_}
        install -Dm0644 $file $out/share/icons/hicolor/''${file_suffix//x32.png}/apps/vencorddesktop.png
      done

      makeWrapper ${electron}/bin/electron $out/bin/vencorddesktop \
        --prefix LD_LIBRARY_PATH : ${libPath} \
        --add-flags $out/opt/Vesktop/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "vencorddesktop";
      desktopName = "Vesktop";
      exec = "vencorddesktop %U";
      icon = "vencorddesktop";
      startupWMClass = "VencordDesktop";
      genericName = "Internet Messenger";
      keywords = [ "discord" "vencord" "electron" "chat" ];
    })
  ];

  meta = with lib; {
    description = "An alternate client for Discord with Vencord built-in";
    homepage = "https://github.com/Vencord/Vesktop";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ getchoo Scrumplex vgskye ];
    platforms = platforms.linux;
    mainProgram = "vencorddesktop";
  };
}
