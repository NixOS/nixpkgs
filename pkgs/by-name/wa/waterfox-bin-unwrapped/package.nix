{
  lib,
  stdenv,
  fetchurl,
  config,
  wrapGAppsHook3,
  autoPatchelfHook,
  alsa-lib,
  curl,
  dbus-glib,
  gtk3,
  libxtst,
  libva,
  pciutils,
  pipewire,
  adwaita-icon-theme,
  writeText,
  patchelfUnstable, # have to use patchelfUnstable to support --no-clobber-old-sections
  applicationName ? "Waterfox",
  undmg,
  nixosTests,
}:

let

  inherit (lib.importJSON ./version.json)
    version
    sources
    ;

  binaryName = "waterfox";

  waterfoxPlatforms = {
    x86_64-linux = "Linux_x86_64";
    # bundles are universal and can be re-used for both darwin architectures
    aarch64-darwin = "Darwin_x86_64-aarch64";
    x86_64-darwin = "Darwin_x86_64-aarch64";
  };

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  arch = waterfoxPlatforms.${stdenv.hostPlatform.system} or throwSystem;

  policies = {
    DisableAppUpdate = true;
  }
  // config.waterfox.policies or { };

  policiesJson = writeText "waterfox-policies.json" (builtins.toJSON { inherit policies; });

  source = lib.findFirst (source: source.arch == arch) { } sources;
in

stdenv.mkDerivation {
  pname = "waterfox-bin-unwrapped";
  inherit version;

  src = fetchurl { inherit (source) url hash; };

  sourceRoot = lib.optional stdenv.hostPlatform.isDarwin ".";

  __structuredAttrs = true;
  strictDeps = true;
  nativeBuildInputs = [
    wrapGAppsHook3
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    autoPatchelfHook
    patchelfUnstable
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    undmg
  ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    gtk3
    adwaita-icon-theme
    alsa-lib
    dbus-glib
    libxtst
  ];
  runtimeDependencies = [
    curl
    pciutils
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libva.out
  ];
  appendRunpaths = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "${pipewire}/lib"
  ];
  # Firefox uses "relrhack" to manually process relocations from a fixed offset
  patchelfFlags = [ "--no-clobber-old-sections" ];

  # don't break code signing
  dontFixup = stdenv.hostPlatform.isDarwin;

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications
        mv Waterfox*.app "$out/Applications/${applicationName}.app"
      ''
    else
      ''
        mkdir -p "$prefix/lib/waterfox-bin-${version}"
        cp -r * "$prefix/lib/waterfox-bin-${version}"

        mkdir -p "$out/bin"
        ln -s "$prefix/lib/waterfox-bin-${version}/waterfox" "$out/bin/${binaryName}"

        # See: https://github.com/mozilla/policy-templates/blob/master/README.md
        mkdir -p "$out/lib/waterfox-bin-${version}/distribution";
        ln -s ${policiesJson} "$out/lib/waterfox-bin-${version}/distribution/policies.json";
      '';

  passthru = {
    inherit applicationName binaryName;
    libName = "waterfox-bin-${version}";
    ffmpegSupport = true;
    gssSupport = true;
    gtk3 = gtk3;

    # update with:
    # $ nix-shell maintainers/scripts/update.nix --argstr package waterfox-bin-unwrapped
    updateScript = ./update.py;

    tests = { inherit (nixosTests) waterfox-bin; };
  };

  meta = {
    changelog = "https://www.waterfox.com/releases/${version}/";
    description = "Waterfox, a privacy focused, performance oriented browser based on Firefox (binary package)";
    homepage = "https://www.waterfox.com/";
    license = lib.licenses.mpl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames waterfoxPlatforms;
    hydraPlatforms = [ ];
    maintainers = with lib.maintainers; [
      maximsmol
    ];
    mainProgram = binaryName;
  };
}
