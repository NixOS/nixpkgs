{
  lib,
  mkLxgwFont,
  fetchurl,
}:

let
  srcs = lib.importJSON ./sources.json;

  fonts = {
    neozhisong = {
      fontName = "LXGWNeoZhiSong";
      repoName = "LxgwNeoZhiSong";
      meta.description = "Chinese serif font derived from IPAmj Mincho";
    };
    neozhisong-plus = {
      fontName = "LXGWNeoZhiSongPlus";
      repoName = "LxgwNeoZhiSong";
      meta.description = "Chinese serif font derived from IPAmj Mincho with full Chinese character extended";
    };

    neoxihei = {
      fontName = "LXGWNeoXiHei";
      repoName = "LxgwNeoXiHei";
      meta.description = "Chinese sans-serif font derived from IPAex Gothic";
    };
    neoxihei-plus = {
      fontName = "LXGWNeoXiHeiPlus";
      repoName = "LxgwNeoXiHei";
      meta.description = "Chinese sans-serif font derived from IPAex Gothic with full Chinese character extended";
    };

    neoxihei-screen = {
      fontName = "LXGWNeoXiHeiScreen";
      repoName = "LxgwNeoXiZhi-Screen";
      meta.description = "Chinese sans-serif font derived from IPAex Gothic, optimized for screen use";
    };
    neoxihei-screen-full = {
      fontName = "LXGWNeoXiHeiScreenFull";
      repoName = "LxgwNeoXiZhi-Screen";
      meta.description = "Chinese sans-serif font derived from IPAex Gothic with full Chinese character extended, optimized for screen use";
    };
    neozhisong-screen = {
      fontName = "LXGWNeoZhiSongScreen";
      repoName = "LxgwNeoXiZhi-Screen";
      meta.description = "Chinese serif font derived from IPAmj Mincho, optimized for screen use";
    };
    neozhisong-screen-full = {
      fontName = "LXGWNeoZhiSongScreenFull";
      repoName = "LxgwNeoXiZhi-Screen";
      meta.description = "Chinese serif font derived from IPAmj Mincho with full Chinese character extended, optimized for screen use";
    };

    xihei-classic = {
      fontName = "LXGWXiHeiCL";
      repoName = "LxgwXiHei";
      meta.description = "Chinese sans-serif font derived from IPAex Gothic (classic style)";
    };
    xihei-modern = {
      fontName = "LXGWXiHeiMN";
      repoName = "LxgwXiHei";
      meta.description = "Chinese sans-serif font derived from IPAex Gothic (modern style)";
    };

    zhisong-classic = {
      fontName = "LXGWZhiSongCL";
      repoName = "LxgwZhiSong";
      meta.description = "Chinese serif font derived from IPAmj Mincho (classic style)";
    };
    zhisong-modern = {
      fontName = "LXGWZhiSongMN";
      repoName = "LxgwZhiSong";
      meta.description = "Chinese serif font derived from IPAmj Mincho (modern style)";
    };

    neoxihei-code = {
      fontName = "NeoXiHeiCode-Regular";
      repoName = "NeoXiHei-Code";
      meta.description = "NeoXiHei font merged with M+ 1m for programming use";
    };
  };
in

lib.mapAttrs (
  name:
  args@{ fontName, repoName, ... }:
  mkLxgwFont (
    {
      inherit name fontName repoName;
      version = lib.removePrefix "v" srcs.${repoName}.version;
      src = fetchurl srcs.${repoName}.sources.${fontName};
      meta.license = lib.licenses.ipa;
      passthru.updateScript = ./update.sh;
    }
    // args
  )
) fonts
