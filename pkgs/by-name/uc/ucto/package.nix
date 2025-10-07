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
  icu60,
  bzip2,
  libtar,
  ticcutils,
  libfolia,
  uctodata,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ucto";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "ucto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DFQ4ePE3n3zg0mrqUNHzE3Hi81n1IurYjhh6YVAghEE=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    bzip2
    libtool
    autoconf-archive
    icu60
    libtar
    libxml2
    ticcutils
    libfolia
    uctodata
    # TODO textcat from libreoffice? Pulls in X11 dependencies?
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
