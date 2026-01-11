{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  fonts = {
    assamese = {
      label = "Assamese";
      version = "2.91.5";
      hash = "sha256-Oo/hHHFg/Nu3eaZLMdBclY90lKU2AMFUclyXHxGaAgg=";
    };
    bengali = {
      label = "Bengali";
      version = "2.91.5";
      hash = "sha256-QGf94TdQS2c9+wSSDK4Mknw5ubCGTuvg0xoNaJdirBc=";
    };
    devanagari = {
      label = "Devanagari script";
      version = "2.95.4";
      hash = "sha256-6CbOCqOei5eO1zwNQZvB+fFDkqxvJnK82z+zmClhRAE=";
    };
    gujarati = {
      label = "Gujarati";
      version = "2.92.4";
      hash = "sha256-BpwibF0/HXDvXpDEek0fj73cxo2QC1hSfQ49Q/ZOZg8=";
    };
    gurmukhi = {
      label = "Gurmukhi script";
      version = "2.91.2";
      hash = "sha256-5iLFW2FEE5LBqoALi+3sUjwC0ADntsp259TP+bYwR9g=";
    }; # renamed from Punjabi
    kannada = {
      label = "Kannada";
      version = "2.5.4";
      hash = "sha256-7y2u0tBdNYCeY7Y+aqhxXP7Qv6GglJeVO1wvM9CzyIQ=";
    };
    malayalam = {
      label = "Malayalam";
      version = "2.92.2";
      hash = "sha256-SzM38vuAlP9OMC8kUuHQylmH8TUjCeg1y/Zcu2I2bjA=";
    };
    marathi = {
      label = "Marathi";
      version = "2.94.2";
      hash = "sha256-jK1Gwcr5gqzRNkbIxs4V/OYgUlUEpU0OYzKDTkiMlqM=";
    };
    nepali = {
      label = "Nepali";
      version = "2.94.2";
      hash = "sha256-OX1ekxeSbVGOrdbZ3Jvu4nii0zkgbuij10JIzqRcFx4=";
    };
    odia = {
      label = "Odia";
      version = "2.91.2";
      hash = "sha256-3/eczBGGZj4QPs7KY0as9zk5HaBfhgz6YgU0qmwpVcA=";
    }; # renamed from Oriya
    tamil-classical = {
      label = "Classical Tamil";
      version = "2.5.4";
      hash = "sha256-6SsddTCEUHMoF7X4+i7eXimmMuktfFAl8uz95RwM+yg=";
    };
    tamil = {
      label = "Tamil";
      version = "2.91.3";
      hash = "sha256-8lcNw87o9lhQsKwCqwBSfx7rhcrH/eEqac7EsA9/w/E=";
    };
    telugu = {
      label = "Telugu";
      version = "2.5.5";
      hash = "sha256-cZh93NfEB+5S1JeEowtBMJ0nbZsFGpbEp2WAtzxrA8A=";
    };
  };
  gplfonts = {
    # GPL fonts removed from later releases
    kashmiri = {
      label = "Kashmiri";
      version = "2.4.3";
      hash = "sha256-6T2QaWnt3+e5nr4vbk44FouqmeWKzia1lSf8S/bvqCs=";
    };
    konkani = {
      label = "Konkani";
      version = "2.4.3";
      hash = "sha256-hVy2rxrUTPDeNnugi3Bk7z0JqGmk4/yeUsAoI/4R7A8=";
    };
    maithili = {
      label = "Maithili";
      version = "2.4.3";
      hash = "sha256-ikDcpJqdizAYRpgoebzqxOEeodJ6C3fO2rsqGzC0HCs=";
    };
    sindhi = {
      label = "Sindhi";
      version = "2.4.3";
      hash = "sha256-wU3B9fh+8E1bFBMnakzmajY7eNKzed9+eYL5AOxyNQI=";
    };
  };

  mkpkg =
    license: pname:
    {
      label,
      version,
      hash,
    }:
    stdenvNoCC.mkDerivation {
      inherit pname version;

      src = fetchurl {
        url = "https://releases.pagure.org/lohit/lohit-${pname}-ttf-${version}.tar.gz";
        inherit hash;
      };

      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/fonts/truetype
        cp -v *.ttf $out/share/fonts/truetype/

        mkdir -p $out/etc/fonts/conf.d
        cp -v *.conf $out/etc/fonts/conf.d

        mkdir -p "$out/share/doc/lohit-${pname}"
        cp -v ChangeLog* COPYRIGHT* "$out/share/doc/lohit-${pname}/"

        runHook postInstall
      '';

      meta = {
        inherit license;
        description = "Free and open source fonts for Indian languages (" + label + ")";
        homepage = "https://pagure.io/lohit";
        maintainers = [
          lib.maintainers.mathnerd314
          lib.maintainers.ttuegel
        ];
        # Set a non-zero priority to allow easy overriding of the
        # fontconfig configuration files.
        priority = 5;
      };
    };

in
# Technically, GPLv2 with usage exceptions
lib.mapAttrs (mkpkg lib.licenses.gpl2) gplfonts // lib.mapAttrs (mkpkg lib.licenses.ofl) fonts
