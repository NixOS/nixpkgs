{ stdenvNoCC
, lib
, gnat
, gprbuild
, fetchFromGitHub
, writeShellScriptBin
, symlinkJoin
}:

let
  pkg = stdenvNoCC.mkDerivation {
    pname = "whitakers-words";
    version = "1.97FC";

    src = fetchFromGitHub {
      owner = "mk270";
      repo = "whitakers-words";
      rev = "9b11477e53f4adfb17d6f6aa563669dc71e0a680";
      sha256 = "sha256-f/8dQff2min0FivBKTk/kcwwoW5IfajAjsdkALT52xU=";
    };

    nativeBuildInputs = [
      gprbuild
      gnat
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/lib/whitakers-words

      cp -r bin $out/lib/whitakers-words/bin
      cp -r lib $out/lib/whitakers-words/lib
      cp *.GEN $out/lib/whitakers-words/
      cp *.LAT $out/lib/whitakers-words/
      cp *.SEC $out/lib/whitakers-words/

      runHook postInstall
    '';

    meta = {
      description = "A Latin-English dictionary";
      longDescription = ''
        This program, WORDS, takes keyboard input or a file of Latin text lines
        and provides an analysis of each word individually.

        The dictionary contains over 39000 entries, as would be counted in an
        ordinary dictionary. This expands to almost twice that number of
        individual stems and, through additional word construction with hundreds
        of prefixes and suffixes, may generate more, leading to many hundreds of
        thousands of ‘words’ that can be formed by declension and
        conjugation. This version of WORDS provides a tool to help in
        translations for the Latin student. It is now a large dictionary by any
        measure and can be helpful to advanced users. The dictionary will
        continue to grow - slowly.
      '';
      homepage = "http://mk270.github.io/whitakers-words";
      license = lib.licenses.unfreeRedistributable;
      maintainers = [ lib.maintainers.davisrichard437 ];
      mainProgram = "words";
    };
  };

  script = writeShellScriptBin "words"
    ''
      cd ${pkg}/lib/whitakers-words
      ./bin/words "$@"
    '';

in

symlinkJoin {
  inherit (pkg) name meta;
  paths = [ pkg script ];
}
