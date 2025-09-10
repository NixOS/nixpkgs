{
  lib,
  fetchzip,
  wsjtx,
}:

wsjtx.overrideAttrs (
  finalAttrs: old: {
    pname = "wsjtz";
    version = "2.7.0-rc7-1.48";

    src = fetchzip {
      url = "mirror://sourceforge/wsjt-z/Source/wsjtz-${finalAttrs.version}.zip";
      hash = "sha256-8PHbBlF0MtIgLn4HCFkbGivy8vBwg7NbvjMLaRj+4nI=";
    };

    postInstall = ''
      mv $out/bin/wsjtx $out/bin/wsjtz
      mv $out/bin/wsjtx_app_version $out/bin/wsjtz_app_version
    '';

    meta = {
      description = "WSJT-X fork, primarily focused on automation and enhanced functionality";
      homepage = "https://sourceforge.net/projects/wsjt-z/";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [
        scd31
      ];
      mainProgram = "wsjtz";
    };
  }
)
