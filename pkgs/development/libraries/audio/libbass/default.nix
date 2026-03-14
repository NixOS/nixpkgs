{
  lib,
  stdenv,
  unzip,
  fetchurl,
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
        darwin = "bass.h";
      };
      version = "2.4.18.3";
      so = {
        i686_linux = "libs/x86/libbass.so";
        x86_64-linux = "libs/x86_64/libbass.so";
        armv7l-linux = "libs/armhf/libbass.so";
        aarch64-linux = "libs/aarch64/libbass.so";

        i686-darwin = "libbass.dylib";
        x86_64-darwin = "libbass.dylib";
        aarch64-darwin = "libbass.dylib";
      };
      url = {
        linux = "https://web.archive.org/web/20251222154947/https://www.un4seen.com/files/bass24-linux.zip";
        darwin = "https://web.archive.org/web/20250701055605/https://www.un4seen.com/files/bass24-osx.zip";
      };
      hash = {
        linux = "sha256-3iZk+9MaGn7vTbSNprjChICMXhk8Pu4hWHIR3peGkXI=";
        darwin = "sha256-n7y1Dl08a7ZmuSH0oQiNl1YDonYSinzqtSf/QB7g81I=";
      };
    };

    bass_fx = {
      h.linux = "C/bass_fx.h";
      version = "2.4.12.6";
      so = {
        i686_linux = "libs/x86/libbass_fx.so";
        x86_64-linux = "libs/x86_64/libbass_fx.so";
        armv7l-linux = "libs/armhf/libbass_fx.so";
        aarch64-linux = "libs/aarch64/libbass_fx.so";
      };
      url.linux = "https://web.archive.org/web/20250627192213/https://www.un4seen.com/files/z/0/bass_fx24-linux.zip";
      hash.linux = "sha256-Hul2ELwnaDV8TDRMDXoFisle31GATDkf3PdkR2K9QTs=";
    };

    bassmidi = {
      h.linux = "bassmidi.h";
      version = "2.4.15.3";
      so = {
        i686_linux = "libs/x86/libbassmidi.so";
        x86_64-linux = "libs/x86_64/libbassmidi.so";
        armv7l-linux = "libs/armhf/libbassmidi.so";
        aarch64-linux = "libs/aarch64/libbassmidi.so";
      };
      url.linux = "https://web.archive.org/web/20240501180447/http://www.un4seen.com/files/bassmidi24-linux.zip";
      hash.linux = "sha256-HrF1chhGk32bKN3jwal44Tz/ENGe/zORsrLPeGAv1OE=";
    };

    bassmix = {
      h.linux = "bassmix.h";
      version = "2.4.12";
      so = {
        i686_linux = "libs/x86/libbassmix.so";
        x86_64-linux = "libs/x86_64/libbassmix.so";
        armv7l-linux = "libs/armhf/libbassmix.so";
        aarch64-linux = "libs/aarch64/libbassmix.so";
      };
      url.linux = "https://web.archive.org/web/20240930183631/https://www.un4seen.com/files/bassmix24-linux.zip";
      hash.linux = "sha256-oxxBhsjeLvUodg2SOMDH4wUy5na3nxLTqYkB+iXbOgA=";
    };
  };

  dropBass =
    name: bass:
    let
      os =
        if stdenv.hostPlatform.isDarwin then
          "darwin"
        else if stdenv.hostPlatform.isLinux then
          "linux"
        else
          throw "Unsupported OS for ${name}: ${stdenv.hostPlatform.system}";
    in
    stdenv.mkDerivation {
      pname = "lib${name}";
      inherit (bass) version;

      src = fetchurl {
        url = bass.url."${os}";
        hash = bass.hash."${os}";
      };

      unpackCmd = ''
        mkdir out
        ${unzip}/bin/unzip $curSrc -d out
      '';

      lpropagatedBuildInputs = [ unzip ];
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
          install -m644 -t $out/include/ ${bass.h."${os}"}
        '';

      meta = {
        description = "Shareware audio library";
        homepage = "https://www.un4seen.com/";
        license = lib.licenses.unfreeRedistributable;
        platforms = builtins.attrNames bass.so;
        maintainers = with lib.maintainers; [ poz ];
      };
    };

in
lib.mapAttrs dropBass allBass
