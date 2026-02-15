{
  lib,
  mkLxgwFont,
  fetchurl,
  p7zip,
}:

let
  srcs = lib.importJSON ./sources.json;

  fonts = {
    pengli-wenkai = {
      fontName = "PengliWenKai-Regular";
      repoName = "Pengli";
      meta.description = "Open-source Chinese font derived from LXGW WenKai font based on GB/Z 40637-2021 Standard";
    };
    zhenkai-gb = {
      fontName = "LXGWZhenKaiGB-Regular";
      repoName = "LxgwZhenKai";
      meta.description = "LXGW WenKai font bold derivative open-source Simplified Chinese font";
    };
    zhenkai-slab-gb = {
      fontName = "LXGWZhenKaiSlabGB-Regular";
      repoName = "LxgwZhenKai";
      meta.description = "LXGW WenKai font bold derivative open-source Simplified Chinese font (slab)";
    };
    zhenkai-gbk = {
      fontName = "ZhenKai_GBK-Regular";
      repoName = "LxgwZhenKai";
      meta.description = "LXGW WenKai font bold derivative open-source Simplified Chinese font (GBK)";
    };
    xiaolai = {
      fontName = "Xiaolai-Regular";
      repoName = "kose-font";
      meta.description = "Open-source Chinese Font derived from SetoFont";
    };
    xiaolai-mono = {
      fontName = "XiaolaiMono-Regular";
      repoName = "kose-font";
      meta.description = "Open-source Chinese Font derived from SetoFont";
    };
    yozai = {
      fontName = "Yozai-Regular";
      repoName = "yozai-font";
      meta.description = "Open-source Chinese font derived from Y.OzFont";
    };
    yozai-light = {
      fontName = "Yozai-Light";
      repoName = "yozai-font";
      meta.description = "Open-source Chinese font derived from Y.OzFont";
    };
    yozai-medium = {
      fontName = "Yozai-Medium";
      repoName = "yozai-font";
      meta.description = "Open-source Chinese font derived from Y.OzFont";
    };
    bright = {
      fontName = "LXGWBright";
      repoName = "LxgwBright";
      suffix = "7z";
      meta.description = "LXGW WenKai font merged with Ysabeau font";
    };
    bright-gb = {
      fontName = "LXGWBrightGB";
      repoName = "LxgwBright";
      suffix = "7z";
      meta.description = "LXGW WenKai font merged with Ysabeau font (GB Edition)";
    };
    bright-tc = {
      fontName = "LXGWBrightTC";
      repoName = "LxgwBright";
      suffix = "7z";
      meta.description = "LXGW WenKai font merged with Ysabeau font (TC Edition)";
    };
    bright-code = {
      fontName = "LxgwBrightCode";
      repoName = "LxgwBright-Code";
      suffix = "7z";
      meta.description = "LXGW WenKai font merged with Monaspace Argon font";
    };
    bright-code-gb = {
      fontName = "LxgwBrightCodeGB";
      repoName = "LxgwBright-Code";
      suffix = "7z";
      meta.description = "LXGW WenKai font merged with Monaspace Argon font (GB Edition)";
    };
    bright-code-tc = {
      fontName = "LxgwBrightCodeTC";
      repoName = "LxgwBright-Code";
      suffix = "7z";
      meta.description = "LXGW WenKai font merged with Monaspace Argon font (TC Edition)";
    };
    fusionkai = {
      fontName = "FusionKai";
      repoName = "FusionKai";
      suffix = "tar.gz";
      meta.description = "Open-source Chinese font derived from LXGW WenKai, iansui and Klee One";
    };
    fusionkai-jp = {
      fontName = "FusionKaiJ-Regular";
      repoName = "FusionKai";
      meta.description = "Open-source Chinese font derived from LXGW WenKai TC and Klee One (JP Priority)";
    };
    fusionkai-tc = {
      fontName = "FusionKaiT-Regular";
      repoName = "FusionKai";
      meta.description = "Open-source Chinese font derived from LXGW WenKai GB and iansui (TC Priority)";
    };
    marker-gothic = {
      fontName = "LXGWMarkerGothic-Regular";
      repoName = "LxgwMarkerGothic";
      meta.description = "Open-source Chinese font derived from Tanugo";
    };
  };
in

lib.mapAttrs (
  name:
  args@{
    fontName,
    repoName,
    suffix ? "ttf",
    ...
  }:
  mkLxgwFont (
    {
      inherit name fontName repoName;
      version = lib.removePrefix "v" srcs.${repoName}.version;
      src = fetchurl srcs.${repoName}.sources.${fontName};
      nativeBuildInputs = lib.optionals (suffix == "7z") [ p7zip ];
      meta.license = lib.licenses.ofl;
      passthru.updateScript = ./update.sh;
    }
    // args
  )
) fonts
