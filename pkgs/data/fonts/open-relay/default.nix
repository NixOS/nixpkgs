{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

let
  mkOpenRelayTypeface =
    name:
    { directory, meta }:
    stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "open-relay-${name}";
      version = "2025-09-01";

      src = fetchFromGitHub {
        owner = "kreativekorp";
        repo = "open-relay";
        tag = finalAttrs.version;
        hash = "sha256-+vG9gzbb3x7Fh3xIpUJZRpclz1qT+gyTSqmOtKJXZtw=";
      };

      installPhase = ''
        runHook preInstall


        install -D -m444 -t "$out/share/fonts/truetype" "${directory}/"*.ttf
        install -D -m644 -t "$out/share/doc/${finalAttrs.pname}-${finalAttrs.version}" "${directory}/OFL.txt"

        runHook postInstall
      '';

      meta = {
        homepage = "https://www.kreativekorp.com/software/fonts/index.shtml";
        description = "Free and open source fonts from Kreative Software";
        license = lib.licenses.ofl;
        platforms = lib.platforms.all;
        maintainers = with lib.maintainers; [
          linus
          toastal
        ];
      }
      // meta;
    });
in
lib.mapAttrs mkOpenRelayTypeface {
  constructium = {
    directory = "Constructium";
    meta = {
      homepage = "https://www.kreativekorp.com/software/fonts/constructium/";
      description = "Fork of SIL Gentium designed specifically to support constructed scripts as encoded in the Under-ConScript Unicode Registry";
      longDescription = ''
        Constructium is a fork of SIL Gentium designed specifically to support
        constructed scripts as encoded in the Under-ConScript Unicode Registry.
        It is ideal for mixed Latin, Greek, Cyrillic, IPA, and conlang text in
        web sites and documents.
      '';
    };
  };

  fairfax = {
    directory = "Fairfax";
    meta = {
      homepage = "https://www.kreativekorp.com/software/fonts/fairfax/";
      description = "6×12 bitmap font supporting many Unicode blocks & scripts as well as constructed scripts";
      longDescription = ''
        Fairfax is a 6×12 bitmap font for terminals, text editors, IDEs, etc. It
        supports many scripts and a large number of Unicode blocks as well as
        constructed scripts as encoded in the Under-ConScript Unicode Registry,
        pseudographics and semigraphics, and tons of private use characters. It
        has been superceded by Fairfax HD but is still maintained.
      '';
    };
  };

  fairfax-hd = {
    directory = "FairfaxHD";
    meta = {
      homepage = "https://www.kreativekorp.com/software/fonts/fairfaxhd/";
      description = "Halfwidth scalable monospace font supporting many Unicode blocks & script as well as constructed scripts";
      longDescription = ''
        Fairfax HD is a halfwidth scalable monospace font for terminals, text
        editors, IDEs, etc. It supports many scripts and a large number of
        Unicode blocks as well as constructed scripts as encoded in the
        Under-ConScript Unicode Registry, pseudographics and semigraphics, and
        tons of private use characters.
      '';
    };
  };

  kreative-square = {
    directory = "KreativeSquare";
    meta = {
      homepage = "https://www.kreativekorp.com/software/fonts/ksquare/";
      description = "Fullwidth scalable monospace font designed specifically to support pseudographics, semigraphics, and private use characters";
    };
  };
}
