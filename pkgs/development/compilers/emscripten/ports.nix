{ stdenv
, fetchzip
, coreutils
, emscriptenCache
}:

let

  mkEmscriptenPortsDerivation = { name, url, sha256, depends ? [ ], extraSuffixes ? [ ] }:
    let

      extension = builtins.elemAt (builtins.match ".*\\.([^.]+)" url) 0;

      sourceCache = derivation {
        system = builtins.currentSystem;
        name = "${name}-emscripten-port-source-cache";
        builder = stdenv.shell;
        source = fetchzip {
          inherit url sha256;
          stripRoot = false;
        };
        args = [
          "-c"
          ''
            ${coreutils}/bin/mkdir -p $out/share/emscripten/cache/ports/${name}
            ${coreutils}/bin/cp --recursive $source/. $out/share/emscripten/cache/ports/${name}
            ${coreutils}/bin/touch $out/share/emscripten/cache/ports/${name}.${extension}
            echo '${url}' > $out/share/emscripten/cache/ports/${name}/.emscripten_url
          ''
        ];
      };
    in
    emscriptenCache.override {
      emscriptenInheritCaches = [ emscriptenCache sourceCache ] ++ depends;
      emscriptenCachePackages = [ name ] ++ map (extra: "${name}${extra}") extraSuffixes;
    };

  portsSpecs = {
    # URL, suffixes, extras and depends must match those that embuilder.py expects
    sdl2 = {
      url = "https://github.com/libsdl-org/SDL/archive/release-2.24.2.zip";
      sha256 = "sha256-foIyqJyUYya4oHkPrtGdnoMcOv16HolYExmiQOPBvBk=";
      extraSuffixes = [ "-mt" ];
    };
    boost_headers = {
      url = "https://github.com/emscripten-ports/boost/releases/download/boost-1.75.0/boost-headers-1.75.0.zip";
      sha256 = "sha256-ezwSMlIzchKAcxy+ixFxP0clEWngaT5waMSSp082z84=";
    };
    sdl2_gfx = {
      url = "https://github.com/svn2github/sdl2_gfx/archive/2b147ffef10ec541d3eace326eafe11a54e635f8.zip";
      sha256 = "sha256-Lh/wLgUzkTJ+a5DHgQc/JmGNL5QmvwvnoLLC1JZOR84=";
      depends = [ ports.sdl2 ];
    };
    sdl2_image = {
      url = "https://github.com/libsdl-org/SDL_image/archive/refs/tags/release-2.6.0.zip";
      sha256 = "sha256-u1MXDxu6ZTcuQfmK+GhMsRopnORjdHN6hLoW+KHQjVo=";
      depends = [ ports.sdl2 ];
    };
    sdl2_mixer = {
      url = "https://github.com/libsdl-org/SDL_mixer/archive/release-2.0.4.zip";
      sha256 = "sha256-BQ3yaxB1V/rATjWSaEuHc3ZAi1iyNG2b2ed9SeIDNQQ=";
      depends = [ ports.vorbis ports.sdl2 ];
    };
    sdl2_net = {
      url = "https://github.com/emscripten-ports/SDL2_net/archive/version_2.zip";
      sha256 = "sha256-NWXgVSIvHIoE5YQUnSAcVvuutKhxa0AuPZhodvb4k3k=";
      depends = [ ports.sdl2 ];
    };
    sdl2_ttf = {
      url = "https://github.com/libsdl-org/SDL_ttf/archive/release-2.20.2.zip";
      sha256 = "sha256-JUzOjGeQMR2mPCNZ0tZh/87401kBoCMi0mWjofdMxjc=";
      depends = [ ports.sdl2 ports.harfbuzz ];
    };
    bullet = {
      url = "https://github.com/emscripten-ports/bullet/archive/version_1.zip";
      sha256 = "sha256-pcmCUE++CXY+xegV8prSrWq79iwDnKmVEhWHIVaeH7Q=";
    };
    bzip2 = {
      url = "https://github.com/emscripten-ports/bzip2/archive/1.0.6.zip";
      sha256 = "sha256-LKYisuMW9OGMJX04epqTYQ9RkUdLTRXZ7nGF1J8V7oY=";
    };
    cocos2d = {
      url = "https://github.com/emscripten-ports/Cocos2d/archive/version_3_3.zip";
      sha256 = "sha256-AoN+NT170jy/Iw+LLdVHQdwRQ1/rIE26fUj10wxUu0g=";
      depends = [ ports.libpng ];
    };
    harfbuzz = {
      url = "https://github.com/harfbuzz/harfbuzz/releases/download/3.2.0/harfbuzz-3.2.0.tar.xz";
      sha256 = "sha256-OJ9dKDcwnqDsHlc1mzyuWY8UMvZSCrrRMJ/5gOAczjA=";
      extraSuffixes = [ "-mt" ];
      depends = [ ports.freetype ];
    };
    freetype = {
      url = "https://github.com/emscripten-ports/FreeType/archive/version_1.zip";
      sha256 = "sha256-mawoDIWaYHHw+8bFgAhSQkx5DEooVxW1yZhGcxyygQM=";
    };
    icu = {
      url = "https://github.com/unicode-org/icu/releases/download/release-68-2/icu4c-68_2-src.zip";
      sha256 = "sha256-4SDmJ4ISORm6K31OTtD9ik8QQuOte9i2jYaWjluQWnI=";
      extraSuffixes = [ "-mt" ];
    };
    libjpeg = {
      url = "https://storage.googleapis.com/webassembly/emscripten-ports/jpegsrc.v9c.tar.gz";
      sha256 = "sha256-SZ0g9UsM8VcXu2DfF/k9FUa6V7W2f5GPGQk4buWdU4s=";
    };
    libmodplug = {
      url = "https://github.com/jancc/libmodplug/archive/v11022021.zip";
      sha256 = "sha256-hzXN30IocklLty8daZSF5rHQJ4xHKLWzCQP7o0m5Z0s=";
    };
    libpng = {
      url = "https://storage.googleapis.com/webassembly/emscripten-ports/libpng-1.6.39.tar.gz";
      sha256 = "sha256-Msu/iLhWkOo1ZEfIg2PooArweEKPG4HbfyoO56yMTwA=";
      extraSuffixes = [ "-mt" ];
      depends = [ ports.zlib ];
    };
    mpg123 = {
      url = "https://www.mpg123.de/download/mpg123-1.26.2.tar.bz2";
      sha256 = "sha256-UlxJZOgx1Q2mg03ZnnOmqcw8bda9DkrzBALfWYipp/0=";
    };
    ogg = {
      url = "https://github.com/emscripten-ports/ogg/archive/version_1.zip";
      sha256 = "sha256-sY23SWO9bvyEac/tFRW/8D7aL3HQH09kBJ89hEvdShE=";
    };
    regal = {
      url = "https://github.com/emscripten-ports/regal/archive/version_7.zip";
      sha256 = "sha256-r4S9TTmyWqA3pNpEUKuHy5jCV8kSj21UTSuiNNhZhgQ=";
      extraSuffixes = [ "-mt" ];
    };
    sqlite3 = {
      url = "https://www.sqlite.org/2022/sqlite-amalgamation-3390000.zip";
      sha256 = "sha256-TVvLrcy+P1SpIueHN3ZT8HOqjUtk8wpLmOQJWsusdIM=";
      extraSuffixes = [ "-mt" ];
    };
    vorbis = {
      url = "https://github.com/emscripten-ports/vorbis/archive/version_1.zip";
      sha256 = "sha256-b4TqCb0ADTs70gecNm70ErbgbZzoNdVhBLTAnuY2gxk=";
      depends = [ ports.ogg ];
    };
    zlib = {
      url = "https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz";
      sha256 = "sha256-3PRZTg9Vtg3HMxACsiOTOQkrBsZUEy+setq286woflY=";
    };
  };

  ports = builtins.mapAttrs
    (name: args:
      mkEmscriptenPortsDerivation ({ inherit name; } // args))
    portsSpecs;

in
ports // {
  inherit mkEmscriptenPortsDerivation;
  all = emscriptenCache.override {
    emscriptenInheritCaches = [ emscriptenCache ] ++ builtins.attrValues ports;
    emscriptenCachePackages = [ ];
  };
}
