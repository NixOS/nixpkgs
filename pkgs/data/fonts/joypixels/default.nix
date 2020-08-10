{ stdenv, fetchurl, config
, acceptLicense ? config.joypixels.acceptLicense or false
}:

let inherit (stdenv.hostPlatform.parsed) kernel;

    systemSpecific = {
      darwin = rec {
        systemTag =  "nix-darwin";
        capitalized = systemTag;
        ext = "ttc";
        fontFile = "Apple%20Color%20Emoji.ttc";
        name = "joypixels-apple-color-emoji.ttc";
      };
    }.${kernel.name} or rec {
        systemTag = "nix-os";
        capitalized = "NixOS";
        ext = "ttf";
        fontFile = "joypixels-android.ttf";
        name = fontFile;
      };

    joypixels-free-license = with systemSpecific; {
      spdxId = "LicenseRef-JoyPixels-Free-6.0";
      fullName = "JoyPixels Free License Agreement 6.0";
      url = "https://cdn.joypixels.com/distributions/${systemTag}/license/free-license.pdf";
    };

    joypixels-license-appendix = with systemSpecific; {
      spdxId = "LicenseRef-JoyPixels-NixOS-Appendix";
      fullName = "JoyPixels ${capitalized} License Appendix";
      url = "https://cdn.joypixels.com/distributions/${systemTag}/appendix/joypixels-license-appendix.pdf";
    };

in

assert !acceptLicense -> throw ''
  Use of the JoyPixels font requires acceptance of the license.
    - ${joypixels-free-license.fullName} [1]
    - ${joypixels-license-appendix.fullName} [2]

  You can express acceptance by setting acceptLicense to true in your
  configuration (configuration.nix or config.nix):
    joypixels.acceptLicense = true;

  [1]: ${joypixels-free-license.url}
  [2]: ${joypixels-license-appendix.url}
'';

stdenv.mkDerivation rec {
  pname = "joypixels";
  version = "6.0.0";

  src = with systemSpecific; fetchurl {
    inherit name;
    url = "https://cdn.joypixels.com/distributions/${systemTag}/font/${version}/${fontFile}";
    sha256 = {
      darwin = "043980g0dlp8vd4qkbx6298fwz8ns0iwbxm0f8czd9s7n2xm4npq";
    }.${kernel.name} or "1vxqsqs93g4jyp01r47lrpcm0fmib2n1vysx32ksmfxmprimb75s";
  };

  dontUnpack = true;

  installPhase = with systemSpecific; ''
    install -Dm644 $src $out/share/fonts/truetype/joypixels.${ext}
  '';

  meta = with stdenv.lib; {
    description = "The finest emoji you can use legally (formerly EmojiOne)";
    longDescription = ''
      New for 2020! JoyPixels 6.0 includes 3,342 originally crafted icon
      designs and is 100% Unicode 13 compatible. We offer the largest selection
      of files ranging from png, svg, iconjar, sprites, and fonts.
    '';
    homepage = "https://www.joypixels.com/fonts";
    license = let free-license = joypixels-free-license;
                  appendix = joypixels-license-appendix;
      in {
        spdxId = "LicenseRef-JoyPixels-Free-6.0-with-${capitalized}-Appendix";
        fullName = "${free-license.fullName} with ${appendix.fullName}";
        url = free-license.url;
        appendixUrl = appendix.url;
      };
    maintainers = with maintainers; [ toonn jtojnar ];
  };
}
