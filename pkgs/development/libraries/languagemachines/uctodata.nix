{ stdenv, fetchurl
, automake, autoconf, libtool, pkgconfig, autoconf-archive
, libxml2, icu
, languageMachines }:

let
  release = builtins.fromJSON (builtins.readFile ./release-info/LanguageMachines-uctodata.json);
in

stdenv.mkDerivation {
  name = "uctodata";
  version = release.version;
  src = fetchurl { inherit (release) url sha256;
                   name = "uctodata-${release.version}.tar.gz"; };
  buildInputs = [ automake autoconf libtool pkgconfig autoconf-archive ];
  preConfigure = "sh bootstrap.sh";

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
