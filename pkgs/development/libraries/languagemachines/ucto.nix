{ stdenv, fetchurl
, automake, autoconf, libtool, pkgconfig, autoconf-archive
, libxml2, icu
, languageMachines
}:

let
  release = builtins.fromJSON (builtins.readFile ./release-info/LanguageMachines-ucto.json);
in

stdenv.mkDerivation {
  name = "ucto";
  version = release.version;
  src = fetchurl { inherit (release) url sha256;
                   name = "ucto-${release.version}.tar.gz"; };
  buildInputs = [ automake autoconf libtool pkgconfig autoconf-archive
                  icu libxml2
                  languageMachines.ticcutils
                  languageMachines.libfolia
                  languageMachines.uctodata
                  # TODO textcat from libreoffice? Pulls in X11 dependencies?
                ];
  preConfigure = "sh bootstrap.sh;";

  postInstall = ''
    # ucto expects the data files installed in the same prefix
    mkdir -p $out/share/ucto/;
    for f in ${languageMachines.uctodata}/share/ucto/*; do
      echo "Linking $f"
      ln -s $f $out/share/ucto/;
    done;
  '';

  meta = with stdenv.lib; {
    description = "A rule-based tokenizer for natural language";
    homepage    = https://languagemachines.github.io/ucto/;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ roberth ];

    longDescription = ''
      Ucto tokenizes text files: it separates words from punctuation, and splits sentences. It offers several other basic preprocessing steps such as changing case that you can all use to make your text suited for further processing such as indexing, part-of-speech tagging, or machine translation.

      Ucto comes with tokenisation rules for several languages and can be easily extended to suit other languages. It has been incorporated for tokenizing Dutch text in Frog, a Dutch morpho-syntactic processor.
    '';
  };

}
