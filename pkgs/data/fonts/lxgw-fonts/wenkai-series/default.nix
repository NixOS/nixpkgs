{
  lib,
  mkLxgwFont,
  fetchurl,
}:

let
  srcs = lib.importJSON ./sources.json;

  fonts = {
    wenkai = {
      fontName = "LXGWWenKai-Regular";
      repoName = "LXGWWenKai";
    };
    wenkai-light = {
      fontName = "LXGWWenKai-Light";
      repoName = "LXGWWenKai";
    };
    wenkai-medium = {
      fontName = "LXGWWenKai-Medium";
      repoName = "LXGWWenKai";
    };
    wenkai-mono = {
      fontName = "LXGWWenKaiMono-Regular";
      repoName = "LXGWWenKai";
    };
    wenkai-mono-light = {
      fontName = "LXGWWenKaiMono-Light";
      repoName = "LXGWWenKai";
    };
    wenkai-mono-medium = {
      fontName = "LXGWWenKaiMono-Medium";
      repoName = "LXGWWenKai";
    };
    wenkai-full = {
      fontName = "LXGWWenKai";
      repoName = "LXGWWenKai";
      suffix = "tar.gz";
    };
    wenkai-gb = {
      fontName = "LXGWWenKaiGB-Regular";
      repoName = "LXGWWenKaiGB";
    };
    wenkai-gb-light = {
      fontName = "LXGWWenKaiGB-Light";
      repoName = "LXGWWenKaiGB";
    };
    wenkai-gb-medium = {
      fontName = "LXGWWenKaiGB-Medium";
      repoName = "LXGWWenKaiGB";
    };
    wenkai-mono-gb = {
      fontName = "LXGWWenKaiMonoGB-Regular";
      repoName = "LXGWWenKaiGB";
    };
    wenkai-mono-gb-light = {
      fontName = "LXGWWenKaiMonoGB-Light";
      repoName = "LXGWWenKaiGB";
    };
    wenkai-mono-gb-medium = {
      fontName = "LXGWWenKaiMonoGB-Medium";
      repoName = "LXGWWenKaiGB";
    };
    wenkai-gb-full = {
      fontName = "LXGWWenKaiGB";
      repoName = "LXGWWenKaiGB";
      suffix = "tar.gz";
    };
    wenkai-screen = {
      fontName = "LXGWWenKaiScreen";
      repoName = "LXGWWenKai-Screen";
    };
    wenkai-gb-screen = {
      fontName = "LXGWWenKaiGBScreen";
      repoName = "LXGWWenKai-Screen";
    };
    wenkai-mono-screen = {
      fontName = "LXGWWenKaiMonoScreen";
      repoName = "LXGWWenKai-Screen";
    };
    wenkai-mono-gb-screen = {
      fontName = "LXGWWenKaiMonoGBScreen";
      repoName = "LXGWWenKai-Screen";
    };
    wenkai-tc = {
      fontName = "LXGWWenKaiTC-Regular";
      repoName = "LXGWWenKaiTC";
    };
    wenkai-tc-light = {
      fontName = "LXGWWenKaiTC-Light";
      repoName = "LXGWWenKaiTC";
    };
    wenkai-tc-medium = {
      fontName = "LXGWWenKaiTC-Medium";
      repoName = "LXGWWenKaiTC";
    };
    wenkai-mono-tc = {
      fontName = "LXGWWenKaiMonoTC-Regular";
      repoName = "LXGWWenKaiTC";
    };
    wenkai-mono-tc-light = {
      fontName = "LXGWWenKaiMonoTC-Light";
      repoName = "LXGWWenKaiTC";
    };
    wenkai-mono-tc-medium = {
      fontName = "LXGWWenKaiMonoTC-Medium";
      repoName = "LXGWWenKaiTC";
    };
    wenkai-tc-full = {
      fontName = "LXGWWenKaiTC";
      repoName = "LXGWWenKaiTC";
      suffix = "tar.gz";
    };
    wenkai-kr = {
      fontName = "LXGWWenKaiKR-Regular";
      repoName = "LXGWWenKaiKR";
    };
    wenkai-kr-light = {
      fontName = "LXGWWenKaiKR-Light";
      repoName = "LXGWWenKaiKR";
    };
    wenkai-kr-medium = {
      fontName = "LXGWWenKaiKR-Medium";
      repoName = "LXGWWenKaiKR";
    };
    wenkai-mono-kr = {
      fontName = "LXGWWenKaiMonoKR-Regular";
      repoName = "LXGWWenKaiKR";
    };
    wenkai-mono-kr-light = {
      fontName = "LXGWWenKaiMonoKR-Light";
      repoName = "LXGWWenKaiKR";
    };
    wenkai-mono-kr-medium = {
      fontName = "LXGWWenKaiMonoKR-Medium";
      repoName = "LXGWWenKaiKR";
    };
    wenkai-kr-full = {
      fontName = "LXGWWenKaiKR";
      repoName = "LXGWWenKaiKR";
      suffix = "tar.gz";
    };
    wenkai-lite = {
      fontName = "LXGWWenKaiLite-Regular";
      repoName = "LXGWWenKai-Lite";
    };
    wenkai-lite-light = {
      fontName = "LXGWWenKaiLite-Light";
      repoName = "LXGWWenKai-Lite";
    };
    wenkai-lite-medium = {
      fontName = "LXGWWenKaiLite-Medium";
      repoName = "LXGWWenKai-Lite";
    };
    wenkai-mono-lite = {
      fontName = "LXGWWenKaiMonoLite-Regular";
      repoName = "LXGWWenKai-Lite";
    };
    wenkai-mono-lite-light = {
      fontName = "LXGWWenKaiMonoLite-Light";
      repoName = "LXGWWenKai-Lite";
    };
    wenkai-mono-lite-medium = {
      fontName = "LXGWWenKaiMonoLite-Medium";
      repoName = "LXGWWenKai-Lite";
    };
    wenkai-lite-full = {
      fontName = "LXGWWenKai-Lite";
      repoName = "LXGWWenKai-Lite";
      suffix = "tar.gz";
    };
    wenkai-gb-lite = {
      fontName = "LXGWWenKaiGBLite-Regular";
      repoName = "LXGWWenKaiGB-Lite";
    };
    wenkai-gb-lite-light = {
      fontName = "LXGWWenKaiGBLite-Light";
      repoName = "LXGWWenKaiGB-Lite";
    };
    wenkai-gb-lite-medium = {
      fontName = "LXGWWenKaiGBLite-Medium";
      repoName = "LXGWWenKaiGB-Lite";
    };
    wenkai-mono-gb-lite = {
      fontName = "LXGWWenKaiMonoGBLite-Regular";
      repoName = "LXGWWenKaiGB-Lite";
    };
    wenkai-mono-gb-lite-light = {
      fontName = "LXGWWenKaiMonoGBLite-Light";
      repoName = "LXGWWenKaiGB-Lite";
    };
    wenkai-mono-gb-lite-medium = {
      fontName = "LXGWWenKaiMonoGBLite-Medium";
      repoName = "LXGWWenKaiGB-Lite";
    };
    wenkai-gb-lite-full = {
      fontName = "LXGWWenKaiGB-Lite";
      repoName = "LXGWWenKaiGB-Lite";
      suffix = "tar.gz";
    };
  };
in

lib.mapAttrs (
  name:
  args@{ fontName, repoName, ... }:
  let
    ext = lib.strings.trim (
      lib.replaceStrings [ "wenkai" "mono" "light" "medium" "full" "-" ] [ "" "" "" "" "" " " ] name
    );
  in
  mkLxgwFont (
    {
      inherit name fontName repoName;
      version = lib.removePrefix "v" srcs.${repoName}.version;
      src = fetchurl srcs.${repoName}.sources.${fontName};
      meta.license = lib.licenses.ofl;
      meta.description =
        if ext == "" then
          "Open-source Chinese font derived from Fontworks' Klee One"
        else
          "Open-source Chinese font derived from Fontworks' Klee One (${lib.strings.toUpper ext} Edition)";
      passthru.updateScript = ./update.sh;
    }
    // args
  )
) fonts
