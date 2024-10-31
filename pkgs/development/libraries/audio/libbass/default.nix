{ lib, stdenv, unzip, fetchurl }:

# Upstream changes files in-place, to update:
# 1. Check latest version at http://www.un4seen.com/
# 2. Update `version`s and `hash` sums.
# See also http://www.un4seen.com/forum/?topic=18614.0

# Internet Archive used due to upstream URLs being unstable

let
  allBass = {
    bass = {
      h = "bass.h";
      version = "2.4.17";
      so = {
        i686_linux = "libs/x86/libbass.so";
        x86_64-linux = "libs/x86_64/libbass.so";
        armv7l-linux = "libs/armhf/libbass.so";
        aarch64-linux = "libs/aarch64/libbass.so";
      };
      url = "https://web.archive.org/web/20240501180538/http://www.un4seen.com/files/bass24-linux.zip";
      hash = "sha256-/JAlvtZtnzuzZjWy3n1WT8Q5ZVLO0BJJAJT7/dELS3o=";
    };

    bass_fx = {
      h = "C/bass_fx.h";
      version = "2.4.12.1";
      so = {
        i686_linux = "libs/x86/libbass_fx.so";
        x86_64-linux = "libs/x86_64/libbass_fx.so";
        armv7l-linux = "libs/armhf/libbass_fx.so";
        aarch64-linux = "libs/aarch64/libbass_fx.so";
      };
      url = "https://web.archive.org/web/20240926184106/https://www.un4seen.com/files/z/0/bass_fx24-linux.zip";
      hash = "sha256-Hul2ELwnaDV8TDRMDXoFisle31GATDkf3PdkR2K9QTs=";
    };

    bassmix = {
      h = "bassmix.h";
      version = "2.4.12";
      so = {
        i686_linux = "libs/x86/libbassmix.so";
        x86_64-linux = "libs/x86_64/libbassmix.so";
        armv7l-linux = "libs/armhf/libbassmix.so";
        aarch64-linux = "libs/aarch64/libbassmix.so";
      };
      url = "https://web.archive.org/web/20240930183631/https://www.un4seen.com/files/bassmix24-linux.zip";
      hash = "sha256-oxxBhsjeLvUodg2SOMDH4wUy5na3nxLTqYkB+iXbOgA=";
    };
  };

  dropBass = name: bass: stdenv.mkDerivation {
    pname = "lib${name}";
    inherit (bass) version;

    src = fetchurl {
      inherit (bass) hash url;
    };

    unpackCmd = ''
      mkdir out
      ${unzip}/bin/unzip $curSrc -d out
    '';

    lpropagatedBuildInputs = [ unzip ];
    dontBuild = true;
    installPhase =
      let so =
            if bass.so ? ${stdenv.hostPlatform.system} then bass.so.${stdenv.hostPlatform.system}
            else throw "${name} not packaged for ${stdenv.hostPlatform.system} (yet).";
      in ''
        mkdir -p $out/{lib,include}
        install -m644 -t $out/lib/ ${so}
        install -m644 -t $out/include/ ${bass.h}
      '';

    meta = with lib; {
      description = "Shareware audio library";
      homepage = "https://www.un4seen.com/";
      license = licenses.unfreeRedistributable;
      platforms = builtins.attrNames bass.so;
      maintainers = with maintainers; [ jacekpoz ];
    };
  };

in lib.mapAttrs dropBass allBass
