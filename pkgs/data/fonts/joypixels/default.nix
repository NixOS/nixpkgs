{
  lib,
  stdenv,
  fetchurl,
  config,
  acceptLicense ? config.joypixels.acceptLicense or false,
}:

let
  inherit (stdenv.hostPlatform.parsed) kernel;

  systemSpecific =
    {
      darwin = rec {
        systemTag = "nix-darwin";
        capitalized = systemTag;
        fontFile = "JoyPixels-SBIX.ttf";
      };
    }
    .${kernel.name} or rec {
      systemTag = "nixos";
      capitalized = "NixOS";
      fontFile = "joypixels-android.ttf";
    };

  joypixels-free-license = with systemSpecific; {
    spdxId = "LicenseRef-JoyPixels-Free-6.0";
    fullName = "JoyPixels Free License Agreement 6.0";
    url = "https://cdn.joypixels.com/distributions/${systemTag}/license/free-license.pdf";
    free = false;
  };

  joypixels-license-appendix = with systemSpecific; {
    spdxId = "LicenseRef-JoyPixels-NixOS-Appendix";
    fullName = "JoyPixels ${capitalized} License Appendix";
    url = "https://cdn.joypixels.com/distributions/${systemTag}/appendix/joypixels-license-appendix.pdf";
    free = false;
  };

  throwLicense = throw ''
    Use of the JoyPixels font requires acceptance of the license.
      - ${joypixels-free-license.fullName} [1]
      - ${joypixels-license-appendix.fullName} [2]

    You can express acceptance by setting acceptLicense to true in your
    configuration. Note that this is not a free license so it requires allowing
    unfree licenses.

    configuration.nix:
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.joypixels.acceptLicense = true;

    config.nix:
      allowUnfree = true;
      joypixels.acceptLicense = true;

    [1]: ${joypixels-free-license.url}
    [2]: ${joypixels-license-appendix.url}
  '';

in

stdenv.mkDerivation rec {
  pname = "joypixels";
  version = "6.6.0";

  src =
    assert !acceptLicense -> throwLicense;
    with systemSpecific;
    fetchurl {
      name = fontFile;
      url = "https://cdn.joypixels.com/distributions/${systemTag}/font/${version}/${fontFile}";
      sha256 =
        {
          darwin = "0qcmb2vn2nykyikzgnlma627zhks7ksy1vkgvpcmqwyxq4bd38d7";
        }
        .${kernel.name} or "17gjaz7353zyprmds64p01qivy2r8pwf88nvvhi57idas2qd604n";
    };

  dontUnpack = true;

  installPhase = with systemSpecific; ''
    runHook preInstall

    install -Dm644 $src $out/share/fonts/truetype/${fontFile}

    runHook postInstall
  '';

  meta = with lib; {
    description = "The finest emoji you can use legally (formerly EmojiOne)";
    longDescription = ''
      Updated for 2021! JoyPixels 6.6 includes 3,559 originally crafted icon
      designs and is 100% Unicode 13.1 compatible. We offer the largest
      selection of files ranging from png, svg, iconjar, sprites, and fonts.
    '';
    homepage = "https://www.joypixels.com/fonts";
    license =
      let
        free-license = joypixels-free-license;
        appendix = joypixels-license-appendix;
      in
      with systemSpecific;
      {
        spdxId = "LicenseRef-JoyPixels-Free-6.0-with-${capitalized}-Appendix";
        fullName = "${free-license.fullName} with ${appendix.fullName}";
        url = free-license.url;
        appendixUrl = appendix.url;
        free = false;
      };
    maintainers = with maintainers; [
      toonn
      jtojnar
    ];
  };
}
