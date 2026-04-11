{
  lib,
  stdenv,
  unzip,
  fetchurl,
  libbass,
  autoPatchelfHook,
}:

# Upstream changes files in-place, to update:
# 1. Check latest version at http://www.un4seen.com/
# 2. Update `version`s and `hash` sums.
# See also http://www.un4seen.com/forum/?topic=18614.0

# Internet Archive used due to upstream URLs being unstable

let
  allBass = {
    bass = {
      h = {
        linux = "c/bass.h";
        darwin = "c/bass.h";
      };
      version = "2.4.18.3";
      so = {
        i686_linux = "libs/x86/libbass.so";
        x86_64-linux = "libs/x86_64/libbass.so";
        armv7l-linux = "libs/armhf/libbass.so";
        aarch64-linux = "libs/aarch64/libbass.so";
        x86_64-darwin = "libbass.dylib";
        aarch64-darwin = "libbass.dylib";
      };
      url = {
        linux = "https://web.archive.org/web/20251222154947/https://www.un4seen.com/files/bass24-linux.zip";
        darwin = "https://web.archive.org/web/20260318192647/https://www.un4seen.com/files/bass24-osx.zip";
      };
      hash = {
        linux = "sha256-3iZk+9MaGn7vTbSNprjChICMXhk8Pu4hWHIR3peGkXI=";
        darwin = "sha256-363WI4iWsCsUSyhwZV+57iRF/ITVwA9+HFb6+TQ85Zw=";
      };
      buildInputs = [ ];
    };

    bass_fx = {
      h = {
        linux = "C/bass_fx.h";
        darwin = "bass_fx.h";
      };
      version = "2.4.12.6";
      so = {
        i686_linux = "libs/x86/libbass_fx.so";
        x86_64-linux = "libs/x86_64/libbass_fx.so";
        armv7l-linux = "libs/armhf/libbass_fx.so";
        aarch64-linux = "libs/aarch64/libbass_fx.so";
        x86_64-darwin = "libbass_fx.dylib";
        aarch64-darwin = "libbass_fx.dylib";
      };
      url = {
        linux = "https://web.archive.org/web/20250627192213/https://www.un4seen.com/files/z/0/bass_fx24-linux.zip";
        darwin = "https://web.archive.org/web/20250927051000/https://www.un4seen.com/files/z/0/bass_fx24-osx.zip";
      };
      hash = {
        linux = "sha256-Hul2ELwnaDV8TDRMDXoFisle31GATDkf3PdkR2K9QTs=";
        darwin = "sha256-655JbaIpzdc9xR0Wx+P9F8dACoElwr4v64ju4axo3Gg=";
      };
      buildInputs = [
        libbass
        stdenv.cc.cc
      ];
    };

    bassmidi = {
      h = {
        linux = "bassmidi.h";
        darwin = "bassmidi.h";
      };
      version = "2.4.15.3";
      so = {
        i686_linux = "libs/x86/libbassmidi.so";
        x86_64-linux = "libs/x86_64/libbassmidi.so";
        armv7l-linux = "libs/armhf/libbassmidi.so";
        aarch64-linux = "libs/aarch64/libbassmidi.so";
        x86_64-darwin = "libbassmidi.dylib";
        aarch64-darwin = "libbassmidi.dylib";
      };
      url = {
        linux = "https://web.archive.org/web/20240501180447/http://www.un4seen.com/files/bassmidi24-linux.zip";
        darwin = "https://web.archive.org/web/20260318193855/https://www.un4seen.com/files/bassmidi24-osx.zip";
      };
      hash = {
        linux = "sha256-HrF1chhGk32bKN3jwal44Tz/ENGe/zORsrLPeGAv1OE=";
        darwin = "sha256-Sqr83pSEv6hGGxgzEBLSg56sLR2QiPLazp0cmKz1vis=";
      };
      buildInputs = [ libbass ];
    };

    bassmix = {
      h = {
        linux = "bassmix.h";
        darwin = "bassmix.h";
      };
      version = "2.4.12";
      so = {
        i686_linux = "libs/x86/libbassmix.so";
        x86_64-linux = "libs/x86_64/libbassmix.so";
        armv7l-linux = "libs/armhf/libbassmix.so";
        aarch64-linux = "libs/aarch64/libbassmix.so";
        x86_64-darwin = "libbassmix.dylib";
        aarch64-darwin = "libbassmix.dylib";
      };
      url = {
        linux = "https://web.archive.org/web/20240930183631/https://www.un4seen.com/files/bassmix24-linux.zip";
        darwin = "https://web.archive.org/web/20260318194151/https://www.un4seen.com/files/bassmix24-osx.zip";
      };
      hash = {
        linux = "sha256-oxxBhsjeLvUodg2SOMDH4wUy5na3nxLTqYkB+iXbOgA=";
        darwin = "sha256-HSu/R7JmPqJfr4jv6MthsdT+7okKm3EYe7+KdR9zSz0=";
      };
      buildInputs = [ libbass ];
    };
  };

  dropBass =
    name: bass:
    stdenv.mkDerivation {
      pname = "lib${name}";
      inherit (bass) version;

      src = fetchurl {
        url = bass.url.${stdenv.hostPlatform.parsed.kernel.name};
        hash = bass.hash.${stdenv.hostPlatform.parsed.kernel.name};
      };

      unpackCmd = ''
        mkdir out
        unzip $curSrc -d out
      '';

      nativeBuildInputs = [ unzip ] ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;
      buildInputs = lib.optionals stdenv.hostPlatform.isLinux bass.buildInputs;
      dontBuild = true;
      installPhase =
        let
          so =
            if bass.so ? ${stdenv.hostPlatform.system} then
              bass.so.${stdenv.hostPlatform.system}
            else
              throw "${name} not packaged for ${stdenv.hostPlatform.system} (yet).";
        in
        ''
          mkdir -p $out/{lib,include}
          install -m644 -t $out/lib/ ${so}
          install -m644 -t $out/include/ ${bass.h.${stdenv.hostPlatform.parsed.kernel.name}}
        '';

      meta = {
        description = "Shareware audio library";
        homepage = "https://www.un4seen.com/";
        license = lib.licenses.unfreeRedistributable;
        platforms = builtins.attrNames bass.so;
        maintainers = with lib.maintainers; [
          poz
          ulysseszhan
        ];
      };
    };

in
lib.mapAttrs dropBass allBass
