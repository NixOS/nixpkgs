{
  stdenvNoCC,
  lib,
  fetchzip,
  makeDesktopItem,
  autoPatchelfHook,
  zlib,
  fontconfig,
  udev,
  gtk3,
  freetype,
  alsa-lib,
  makeShellWrapper,
  libX11,
  libXext,
  libXdamage,
  libXfixes,
  libxcb,
  libXcomposite,
  libXcursor,
  libXi,
  libXrender,
  libXtst,
  libXxf86vm,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  # Keep this setup to easily add more arch support in the future
  arch =
    {
      x86_64-linux = "x86_64";
    }
    .${system} or throwSystem;

  hash =
    {
      x86_64-linux = "sha256-0Cdu1ntG8ZPHbLOIFvVFO6Dj8ZBHl4Rb+MM46luRKj4=";
    }
    .${system} or throwSystem;

  displayname = "XPipe";

in
stdenvNoCC.mkDerivation rec {
  pname = "xpipe";
  version = "12.0";

  src = fetchzip {
    url = "https://github.com/xpipe-io/xpipe/releases/download/${version}/xpipe-portable-linux-${arch}.tar.gz";
    inherit hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeShellWrapper
  ];

  # Ignore libavformat dependencies as we don't need them
  autoPatchelfIgnoreMissingDeps = true;

  buildInputs = [
    fontconfig
    zlib
    udev
    freetype
    gtk3
    alsa-lib
    libX11
    libX11
    libXext
    libXdamage
    libXfixes
    libxcb
    libXcomposite
    libXcursor
    libXi
    libXrender
    libXtst
    libXxf86vm
  ];

  desktopItem = makeDesktopItem {
    categories = [ "Network" ];
    comment = "Your entire server infrastructure at your fingertips";
    desktopName = displayname;
    exec = "/opt/${pname}/cli/bin/xpipe open %U";
    genericName = "Shell connection hub";
    icon = "/opt/${pname}/logo.png";
    name = displayname;
  };

  installPhase = ''
    runHook preInstall

    pkg="${pname}"
    mkdir -p $out/opt/$pkg
    cp -r ./ $out/opt/$pkg

    mkdir -p "$out/bin"
    ln -s "$out/opt/$pkg/cli/bin/xpipe" "$out/bin/$pkg"

    mkdir -p "$out/share/applications"
    cp -r "${desktopItem}/share/applications/" "$out/share/"

    mkdir -p "$out/etc/bash_completion.d"
    ln -s "$out/opt/$pkg/cli/xpipe_completion" "$out/etc/bash_completion.d/$pkg"

    substituteInPlace "$out/share/applications/${displayname}.desktop" --replace "Exec=" "Exec=$out"
    substituteInPlace "$out/share/applications/${displayname}.desktop" --replace "Icon=" "Icon=$out"

    mv "$out/opt/$pkg/app/bin/xpiped" "$out/opt/$pkg/app/bin/xpiped_raw"
    mv "$out/opt/$pkg/app/lib/app/xpiped.cfg" "$out/opt/$pkg/app/lib/app/xpiped_raw.cfg"
    mv "$out/opt/$pkg/app/scripts/xpiped_debug.sh" "$out/opt/$pkg/app/scripts/xpiped_debug_raw.sh"

    makeShellWrapper "$out/opt/$pkg/app/bin/xpiped_raw" "$out/opt/$pkg/app/bin/xpiped" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          fontconfig
          gtk3
          udev
        ]
      }"
    makeShellWrapper "$out/opt/$pkg/app/scripts/xpiped_debug_raw.sh" "$out/opt/$pkg/app/scripts/xpiped_debug.sh" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          fontconfig
          gtk3
          udev
        ]
      }"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cross-platform shell connection hub and remote file manager";
    homepage = "https://github.com/xpipe-io/${pname}";
    downloadPage = "https://github.com/xpipe-io/${pname}/releases/latest";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    changelog = "https://github.com/xpipe-io/${pname}/releases/tag/${version}";
    license = [
      licenses.asl20
      licenses.unfree
    ];
    maintainers = with maintainers; [ crschnick ];
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
