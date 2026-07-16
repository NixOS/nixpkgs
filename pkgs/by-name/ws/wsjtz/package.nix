{
  lib,
  fetchFromGitHub,
  wsjtx,
}:

wsjtx.overrideAttrs (
  finalAttrs: old: {
    pname = "wsjtz";
    version = "2.0.16";

    src = fetchFromGitHub {
      owner = "sq9fve";
      repo = "wsjt-z";
      tag = "v${finalAttrs.version}";
      hash = "sha256-O7HHAr3am4bH4b/RldoaB9LWWhciUbDc+u+lPO60UUY=";
    };

    postInstall = ''
      mv $out/bin/wsjtx $out/bin/wsjtz
      mv $out/bin/wsjtx_app_version $out/bin/wsjtz_app_version
    '';

    meta = {
      description = "WSJT-X fork, primarily focused on automation and enhanced functionality";
      homepage = "https://github.com/sq9fve/wsjt-z";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [
        scd31
      ];
      mainProgram = "wsjtz";
    };
  }
)
