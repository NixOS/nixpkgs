{ lib
, stdenv
, fetchzip
, python3
, config
, acceptLicense ? config.input-fonts.acceptLicense or false
, preset ? "default"
, lineHeight ? "1.2"
}:

let

  throwLicense = throw ''
    Input is available free of charge for private/unpublished usage. This includes things like your personal coding app or for composing plain text documents.
    To use it, you need to agree to its license: https://input.djr.com/license/

    You can express acceptance by setting acceptLicense to true in your
    configuration. Note that this is not a free license so it requires allowing
    unfree licenses.

    configuration.nix:
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.input-fonts.acceptLicense = true;

    config.nix:
      allowUnfree = true;
      input-fonts.acceptLicense = true;

    If you would like to support this project, consider purchasing a license at <http://input.djr.com/buy>.
  '';

  releaseDate = "2015-06-24";

  presetParams = {
    "andale" = "&a=0&g=0&i=topserif&l=serifs&zero=0&asterisk=0&braces=straight&preset=andale";
    "anonymous" = "&a=0&g=ss&i=serif&l=serif&zero=slash&asterisk=height&braces=straight&preset=anonymous";
    "consolas" = "&a=0&g=0&i=serif&l=serif&zero=slash&asterisk=0&braces=straight&preset=consolas";
    "default" = "&a=0&g=0&i=0&l=0&zero=0&asterisk=0&braces=0&preset=default";
    "dejavu" = "&a=0&g=ss&i=serif&l=serifs_round&zero=slash&asterisk=height&braces=straight&preset=dejavu";
    "envy" = "&a=0&g=ss&i=topserif&l=topserif&zero=slash&asterisk=0&braces=0&preset=envy";
    "fira" = "&a=0&g=0&i=serif&l=serifs_round&zero=0&asterisk=0&braces=straight&preset=fira";
    "liberation" = "&a=0&g=ss&i=serif&l=serif&zero=0&asterisk=0&braces=straight&preset=liberation";
    "monaco" = "&a=ss&g=ss&i=serifs&l=serifs&zero=slash&asterisk=0&braces=0&preset=monaco";
    "pragmata" = "&a=0&g=0&i=serif&l=serif&zero=0&asterisk=height&braces=straight&preset=pragmata";
    "sourcecode" = "a=0&g=0&i=topserif&l=serifs_round&zero=0&asterisk=height&braces=straight&preset=sourcecode";
  }.${preset};

  presetHash = (import ./hashes.nix).${preset}.${lineHeight};
in

stdenv.mkDerivation rec {
  pname = "input-fonts";
  version = "1.2";

  src =
    assert !acceptLicense -> throwLicense;
    fetchzip {
      name = "input-fonts-${version}";
      # Add .zip parameter so that zip unpackCmd can match it.
      url = "https://input.djr.com/build/?fontSelection=whole&${presetParams}&line-height=${lineHeight}&accept=I+do&email=&.zip";
      hash = presetHash;
      stripRoot = false;

      postFetch = ''
        # Reset the timestamp to release date for determinism.
        PATH=${lib.makeBinPath [ python3.pkgs.fonttools ]}:$PATH
        for ttf_file in $out/Input_Fonts/*/*/*.ttf; do
          ttx_file=$(dirname "$ttf_file")/$(basename "$ttf_file" .ttf).ttx
          ttx "$ttf_file"
          rm "$ttf_file"
          touch -m -t ${builtins.replaceStrings [ "-" ] [ "" ] releaseDate}0000 "$ttx_file"
          ttx --recalc-timestamp "$ttx_file"
          rm "$ttx_file"
        done
      '';
    };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    find Input_Fonts -name "*.ttf" -exec cp -a {} "$out"/share/fonts/truetype/ \;
    mkdir -p "$out"/share/doc
    cp -a *.txt "$out"/share/doc/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fonts for Code, from Font Bureau";
    longDescription = ''
      Input is a font family designed for computer programming, data,
      and text composition. It was designed by David Jonathan Ross
      between 2012 and 2014 and published by The Font Bureau. It
      contains a wide array of styles so you can fine-tune the
      typography that works best in your editing environment.

      Input Mono is a monospaced typeface, where all characters occupy
      a fixed width. Input Sans and Serif are proportional typefaces
      that are designed with all of the features of a good monospace —
      generous spacing, large punctuation, and easily distinguishable
      characters — but without the limitations of a fixed width.
    '';
    homepage = "https://input.djr.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [
      jtojnar
      romildo
    ];
    platforms = platforms.all;
  };
}
