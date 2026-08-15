{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  wrapGAppsHook3,
  alsa-lib,
  curl,
  dbus-glib,
  gtk3,
  libxtst,
  libva,
  pciutils,
  pipewire,
  adwaita-icon-theme,
  patchelfUnstable, # supports --no-clobber-old-sections, needed for Firefox-family relrhack
}:

let
  binaryName = "waterfox";

  # Waterfox's CDN only publishes x86_64 and aarch64 Linux tarballs today.
  mozillaPlatforms = {
    x86_64-linux = "Linux_x86_64";
    aarch64-linux = "Linux_aarch64";
  };

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  arch = mozillaPlatforms.${stdenv.hostPlatform.system} or throwSystem;

  pname = "waterfox-bin-unwrapped";
  version = "6.6.17";
in
stdenv.mkDerivation {
  strictDeps = true;
  __structuredAttrs = true;

  inherit pname version;

  src = fetchurl {
    url = "https://cdn.waterfox.com/waterfox/releases/${version}/${arch}/waterfox-${version}.tar.bz2";
    hash = "sha256-9nQDEEaHowHif7Oh7+17/r9q3Zl60PPepGWleXy+oiA=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    autoPatchelfHook
    patchelfUnstable
  ];

  buildInputs = [
    gtk3
    adwaita-icon-theme
    alsa-lib
    dbus-glib
    libxtst
  ];

  runtimeDependencies = [
    curl
    libva.out
    pciutils
  ];

  appendRunpaths = [ "${pipewire}/lib" ];

  # Firefox-family binaries use "relrhack" which patches relocations at a fixed
  # offset; autoPatchelfHook needs this flag or it'll corrupt the binary.
  patchelfFlags = [ "--no-clobber-old-sections" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp -r . $out/lib/${pname}-${version}
    ln -s $out/lib/${pname}-${version}/${binaryName} $out/bin/${binaryName}

    runHook postInstall
  '';

  passthru = {
    inherit binaryName;
    applicationName = "Waterfox";
    libName = "${pname}-${version}";
  };

  meta = {
    description = "Firefox-derived web browser focused on privacy and speed (upstream binary release)";
    homepage = "https://www.waterfox.com";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ safwannoobcoder ];
    platforms = builtins.attrNames mozillaPlatforms;
    mainProgram = "waterfox";
    hydraPlatforms = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
