{
  lib,
  fetchurl,
  makeShellWrapper,
  makeDesktopItem,
  stdenv,
  gtk3,
  libXtst,
  glib,
  zlib,
  wrapGAppsHook3,
  copyDesktopItems,
  bintools,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tlaplus-toolbox";
  version = "1.7.4";

  src = fetchurl {
    url = "https://tla.msr-inria.inria.fr/tlatoolbox/branches/${finalAttrs.version}/products/TLAToolbox-${finalAttrs.version}-linux.gtk.x86_64.zip";
    hash = "sha256-eYK2cXJvLIQfkK+onromwhNfAmzWSyCZXCsEORxkjaU=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeShellWrapper
    wrapGAppsHook3
    unzip
  ];

  buildInputs = [ gtk3 ];

  dontWrapGApps = true;

  desktopItems = [
    (makeDesktopItem {
      name = "TLA+Toolbox";
      exec = "tla-toolbox";
      icon = "tla-toolbox";
      comment = "IDE for TLA+";
      desktopName = "TLA+Toolbox";
      genericName = "IDE for TLA+";
      categories = [ "Development" ];
      startupWMClass = "TLA+ Toolbox";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/libexec"
    cp -r . "$out/libexec/toolbox"

    patchelf --set-interpreter ${bintools.dynamicLinker} "$out/libexec/toolbox/toolbox"
    patchelf --set-interpreter ${bintools.dynamicLinker} \
      --add-rpath "${lib.makeLibraryPath [ zlib ]}" \
      "$(find "$out/libexec/toolbox" -name java)"
    patchelf --set-interpreter ${bintools.dynamicLinker} \
      "$(find "$out/libexec/toolbox" -name jspawnhelper)"

    makeShellWrapper $out/libexec/toolbox/toolbox $out/bin/tla-toolbox \
      --chdir "$out/libexec/toolbox" \
      --add-flags "-data ~/.tla-toolbox" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          gtk3
          libXtst
          glib
          zlib
        ]
      }"  \
      "''${gappsWrapperArgs[@]}"

    echo -e "\nCreating TLA Toolbox icons..."
    for icon_in in $(find . -path "./plugins/*/icons/full/etool16/tla_launch_check_wiz_*.png")
    do
      icon_size=$(echo $icon_in | grep -Po "wiz_\K[0-9]+")
      icon_out="$out/share/icons/hicolor/$icon_size""x$icon_size/apps/tla-toolbox.png"
      install -D --mode=0644 "$icon_in" "$icon_out"
    done

    runHook postInstall
  '';

  meta = {
    homepage = "http://research.microsoft.com/en-us/um/people/lamport/tla/toolbox.html";
    description = "IDE for the TLA+ tools";
    mainProgram = "tla-toolbox";
    longDescription = ''
      Integrated development environment for the TLA+ tools, based on Eclipse. You can use it
      to create and edit your specs, run the PlusCal translator, view the pretty-printed
      versions of your modules, run the TLC model checker, and run TLAPS, the TLA+ proof system.
    '';
    # http://lamport.azurewebsites.net/tla/license.html
    license = with lib.licenses; [ mit ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
})
