{
  wsjtx,
  fetchzip,
  lib,
}:

wsjtx.overrideAttrs (old: rec {
  pname = "wsjtz";
  version = "2.7.0-rc7-1.43";

  src = fetchzip {
    url = "mirror://sourceforge/wsjt-z/Source/wsjtz-${version}.zip";
    hash = "sha256-m+P83S5P9v3NPtifc+XjZm/mAOs+NT9fTWXisxuWtZo=";
  };

  postFixup = ''
    mv $out/bin/wsjtx $out/bin/wsjtz
    mv $out/bin/wsjtx_app_version $out/bin/wsjtz_app_version
  '';

  meta = {
    description = "WSJT-X fork, primarily focused on automation and enhanced functionality";
    homepage = "https://sourceforge.net/projects/wsjt-z/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      scd31
    ];
    mainProgram = "wsjtz";
  };
})
