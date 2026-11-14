{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
  writeShellApplication,
  curl,
  gnused,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "unifi-identity-enterprise";
  version = "0.90.0";

  src = fetchurl {
    name = "${finalAttrs.pname}-${finalAttrs.version}.pkg";
    url = "https://fw-download.ubnt.com/data/uid-ui-desktop-app/42db-macOS-0.90.0-cf7eb9f5-2570-4d3c-9501-2c3eac3e7409.pkg";
    hash = "sha256-vS8fJBzcwC07pOA4aK7CHyFY8FFlOOI4DhQyROKrTo4=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    xar
    cpio
  ];

  unpackPhase = ''
    runHook preUnpack

    xar -xf "$src"

    mkdir app && (cd app && gzip -dc < ../UID_Enterprise_Installer.pkg/Payload | cpio -i)

    find app -name '._*' -delete

    sourceRoot=app
    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R "Applications/UID Enterprise.app" "$out/Applications/"

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-unifi-identity-enterprise";
    runtimeInputs = [
      curl
      gnused
      common-updater-scripts
    ];
    text = ''
      download_url="https://download.uid.ui.com/?app=UI-DESKTOP-MACOS"

      final_url="$(
        curl \
          --fail \
          --silent \
          --show-error \
          --location \
          --output /dev/null \
          --write-out '%{url_effective}' \
          "$download_url"
      )"

      new_version="$(printf '%s\n' "$final_url" | sed -nE 's#^.*macOS-([0-9]+(\.[0-9]+)*)-[^/]+\.pkg$#\1#p')"

      if [[ -z "$new_version" ]]; then
        echo "Unable to determine the version from:"
        echo "$final_url"
        exit 1
      fi

      if [[ "${finalAttrs.version}" == "$new_version" ]]; then
        echo "The new version is the same as the old version."
        exit 0
      fi

      update-source-version "${finalAttrs.pname}" "$new_version" "" "$final_url" --ignore-same-version
    '';
  });

  meta = {
    description = "UniFi Identity Enterprise — network access control and VPN client (Ubiquiti)";
    longDescription = ''
      UniFi Identity Enterprise (formerly UniFi Identity) is Ubiquiti's cloud-managed
      Identity-as-a-Service (IDaaS) agent designed for secure access management.

      It allows employees and system administrators to securely authenticate and access
      organizational resources from desktop environments. Key features include:
      - One-click VPN and One-Click Wi-Fi connectivity for seamless remote work access.
      - Single Sign-On (SSO) and Multi-Factor Authentication (MFA) integration for core apps.
      - Door access management and credential verification.
      - Device compliance, network security enforcement, and automated user lifecycle management.
    '';
    homepage = "https://ui.com/identity";
    downloadPage = "https://ui.com/download/app/identity-desktop";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.darwin;
    identifiers = {
      cpeParts = {
        part = "a";
        vendor = "ui";
        product = "unifi_identity_enterprise";
        version = finalAttrs.version;
        target_sw = "macos";
      };
      purlParts = {
        type = "generic";
        spec = "ubiquiti/unifi-identity-enterprise@${finalAttrs.version}";
      };
    };
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
