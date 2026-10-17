{
  lib,
  fetchFromGitHub,
  wsjtx,
}:

wsjtx.overrideAttrs (
  finalAttrs: old: {
    pname = "wsjtz";
    version = "2.0.19";

    src = fetchFromGitHub {
      owner = "sq9fve";
      repo = "wsjt-z";
      tag = "v${finalAttrs.version}";
      hash = "sha256-E2uXkGP+7I4ToUcKhQ5lwDN5q88IH7x6tzUkUgX8uDc=";
    };

    # GCC 16 warns about uninitialized fields in HRDTransceiver's placement-new
    # message handling. Upstream's -Werror turns these warnings into build failures.
    postPatch = (old.postPatch or "") + ''
      substituteInPlace CMakeLists.txt \
        --replace-fail " -Werror " " "
    '';

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
        n3tcat
      ];
      mainProgram = "wsjtz";
    };
  }
)
