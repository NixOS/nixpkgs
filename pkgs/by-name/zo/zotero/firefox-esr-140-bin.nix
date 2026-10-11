# Prebuilt Firefox ESR 140 used as the runtime for Zotero.
# Adapted from pkgs/applications/networking/browsers/firefox-bin/default.nix.
{
  lib,
  stdenv,
  fetchurl,
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
  patchelfUnstable, # have to use patchelfUnstable to support --no-clobber-old-sections
  applicationName ? "Firefox ESR",
  undmg,
}:

let

  version = "140.17.0esr";

  binaryName = "firefox";

  # Hashes from https://archive.mozilla.org/pub/firefox/releases/${version}/SHA256SUMS
  sources = {
    x86_64-linux = {
      url = "mirror://mozilla/firefox/releases/${version}/linux-x86_64/en-US/firefox-${version}.tar.xz";
      hash = "sha256-htBJBwrYC3TY5nR5PiLSiSO0p6HaBrTWVAL5HGehAxQ=";
    };
    aarch64-linux = {
      url = "mirror://mozilla/firefox/releases/${version}/linux-aarch64/en-US/firefox-${version}.tar.xz";
      hash = "sha256-3VefSEBacGXw9kPdtxqN4PSKnZhMJ4Pe4soXMIGFAIQ=";
    };
    i686-linux = {
      url = "mirror://mozilla/firefox/releases/${version}/linux-i686/en-US/firefox-${version}.tar.xz";
      hash = "sha256-m1XL2UojOr8VjwrbJz5YvDS/3hQPTsdx2qwDMd0ZFy4=";
    };
    aarch64-darwin = {
      url = "mirror://mozilla/firefox/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
      hash = "sha256-5GhK/m8tND/3y8AZ7v84OpMINuEWpkB7krCUG5ZJSpc=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "firefox-esr-140-bin: unsupported system ${stdenv.hostPlatform.system}");

  pname = "firefox-esr-140-bin-unwrapped";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl source;

  sourceRoot = lib.optional stdenv.hostPlatform.isDarwin ".";

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
        mv Firefox*.app "$out/Applications/${applicationName}.app"
      ''
    else
      ''
        mkdir -p "$prefix/lib/firefox-bin-${version}"
        cp -r * "$prefix/lib/firefox-bin-${version}"

        mkdir -p "$out/bin"
        ln -s "$prefix/lib/firefox-bin-${version}/firefox" "$out/bin/${binaryName}"
      '';

  passthru = {
    inherit applicationName binaryName;
    libName = "firefox-bin-${version}";
    withFFmpeg = true;
    withGSSAPI = true;
    gtk3 = gtk3;
  };

  meta = {
    changelog = "https://www.firefox.com/en-US/firefox/${lib.removeSuffix "esr" version}/releasenotes/";
    description = "Mozilla Firefox, free web browser (binary package)";
    homepage = "https://www.mozilla.org/firefox/";
    license = lib.licenses.mkLicense {
      shortName = "firefox";
      fullName = "Firefox Terms of Use";
      url = "https://www.mozilla.org/about/legal/terms/firefox/";
      # "You Are Responsible for the Consequences of Your Use of Firefox"
      # (despite the heading, not an indemnity clause) states the following:
      #
      # > You agree that you will not use Firefox to infringe anyone’s rights
      # > or violate any applicable laws or regulations.
      # >
      # > You will not do anything that interferes with or disrupts Mozilla’s
      # > services or products (or the servers and networks which are connected
      # > to Mozilla’s services).
      #
      # This conflicts with FSF freedom 0: "The freedom to run the program as
      # you wish, for any purpose". (Why should Mozilla be involved in
      # instances where you break your local laws just because you happen to
      # use Firefox whilst doing it?)
      free = false;
      redistributable = true; # since MPL-2.0 still applies
    };
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames sources;
    hydraPlatforms = [ ];
    maintainers = with lib.maintainers; [ mynacol ];
    mainProgram = binaryName;
  };
}
