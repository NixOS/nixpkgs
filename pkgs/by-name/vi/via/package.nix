{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "via";
  version = "3.0.0";
  src = fetchurl {
    url = "https://github.com/the-via/releases/releases/download/v${finalAttrs.version}/via-${finalAttrs.version}-linux.AppImage";
    name = "via-${finalAttrs.version}-linux.AppImage";
    sha256 = "sha256-+uTvmrqHK7L5VA/lUHCZZeRYPUrcVA+vjG7venxuHhs=";
  };

  profile = ''
    # Skip prompt to add udev rule.
    # On NixOS you can add this rule with `services.udev.packages = [ pkgs.via ];`.
    export DISABLE_SUDO_PROMPT=1
  '';

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/via-nativia.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/via-nativia.desktop \
      --replace 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share

    mkdir -p $out/etc/udev/rules.d
    echo 'KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"' > $out/etc/udev/rules.d/92-viia.rules
  '';

  meta = {
    description = "Yet another keyboard configurator";
    homepage = "https://caniusevia.com/";
    # Upstream claims to be GPL-3 but doesn't release source code
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "via";
  };
})
