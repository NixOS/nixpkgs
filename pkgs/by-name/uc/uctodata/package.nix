{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  autoreconfHook,
  libtool,
  pkg-config,
  autoconf-archive,
  frog,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uctodata";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "uctodata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mMQevs7Ju86H+6eIPh8mMVFXUwca73Z940DasUGRnOw=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libtool
    autoconf-archive
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests = {
      /**
        Reverse dependencies. Does not respect overrides.
      */
      reverseDependencies = lib.recurseIntoAttrs {
        inherit frog;
      };
    };
  };

  meta = with lib; {
    description = "Rule-based tokenizer for natural language";
    homepage = "https://languagemachines.github.io/ucto/";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ roberth ];

    longDescription = ''
      Ucto tokenizes text files: it separates words from punctuation, and splits sentences. It offers several other basic preprocessing steps such as changing case that you can all use to make your text suited for further processing such as indexing, part-of-speech tagging, or machine translation.

      Ucto comes with tokenisation rules for several languages and can be easily extended to suit other languages. It has been incorporated for tokenizing Dutch text in Frog, a Dutch morpho-syntactic processor.
    '';
  };

})
