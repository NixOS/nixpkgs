{
  lib,
  fetchFromGitHub,
  wsjtx,
}:
wsjtx.overrideAttrs (
  finalAttrs: old: {
    pname = "wsjtz";
    version = "2.0.14";

    src = fetchFromGitHub {
      owner = "sq9fve";
      repo = "wsjt-z";
      tag = "v${finalAttrs.version}";
      hash = "sha256-pgOGNA/EpyEj9qu61cbZsjv9sKDYKvNpfe8FBAcHkM8=";
    };

    postInstall = ''
      mv $out/bin/wsjtx $out/bin/wsjtz
      mv $out/bin/wsjtx_app_version $out/bin/wsjtz_app_version
    '';

    # Source isn't available in Git.
    passthru = lib.removeAttrs old.passthru [ "updateScript" ];

    meta = {
      description = "WSJT-X fork, primarily focused on automation and enhanced functionality";
      homepage = "https://sourceforge.net/projects/wsjt-z/";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [
        scd31
        fstracke
      ];
      mainProgram = "wsjtz";
    };
  }
)
