{
  lib,
  fetchFromGitHub,
  wsjtx,
}:

wsjtx.overrideAttrs (
  finalAttrs: old: {
    pname = "wsjtz";
    version = "2.0.18";

    src = fetchFromGitHub {
      owner = "sq9fve";
      repo = "wsjt-z";
      tag = "v${finalAttrs.version}";
      hash = "sha256-YxO4pSdKKeO0Ye7Ay/0gdjPvceLbC5eMQk1ZBh1ZHCw=";
    };

    postInstall = ''
      mv $out/bin/wsjtx $out/bin/wsjtz
      mv $out/bin/wsjtx_app_version $out/bin/wsjtz_app_version

      substituteInPlace $out/share/applications/wsjtx.desktop \
        --replace-fail "Exec=wsjtx" "Exec=wsjtz" \
        --replace-fail "Name=wsjtx" "Name=wsjtz"
    '';

    meta = {
      description = "WSJT-X fork, primarily focused on automation and enhanced functionality";
      homepage = "https://github.com/sq9fve/wsjt-z";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [
        Cryolitia
        scd31
      ];
      mainProgram = "wsjtz";
    };
  }
)
