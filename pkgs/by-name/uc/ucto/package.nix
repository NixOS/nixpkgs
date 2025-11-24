{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  autoreconfHook,
  libtool,
  pkg-config,
  autoconf-archive,
  libxml2,
  icu,
  bzip2,
  libtar,
  libexttextcat,
  ticcutils,
  libfolia,
  uctodata,
  frog,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ucto";
  version = "0.35";

  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "ucto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DaLoq+FBNZG4J+h9fRh9HHl2TKVXUTrt9RAzwmv6lIc=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    bzip2
    libtool
    autoconf-archive
    icu
    libtar
    libxml2
    libexttextcat
    ticcutils
    libfolia
    uctodata
  ];

  postInstall = ''
    # ucto expects the data files installed in the same prefix
    mkdir -p $out/share/ucto/;
    for f in ${uctodata}/share/ucto/*; do
      echo "Linking $f"
      ln -s $f $out/share/ucto/;
    done;
  '';

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
    mainProgram = "ucto";
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
