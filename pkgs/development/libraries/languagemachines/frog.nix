{ stdenv, fetchurl
, automake, autoconf, libtool, pkgconfig, autoconf-archive
, libxml2, icu
, languageMachines
}:

let
  release = builtins.fromJSON (builtins.readFile ./release-info/LanguageMachines-frog.json);
in

stdenv.mkDerivation {
  name = "frog";
  version = release.version;
  src = fetchurl { inherit (release) url sha256;
                   name = "frog-${release.version}.tar.gz"; };
  buildInputs = [ automake autoconf libtool pkgconfig autoconf-archive
                  libxml2 icu
                  languageMachines.ticcutils
                  languageMachines.timbl
                  languageMachines.mbt
                  languageMachines.libfolia
                  languageMachines.ucto
                  languageMachines.frogdata
                ];

  preConfigure = ''
    sh bootstrap.sh
  '';
  postInstall = ''
    # frog expects the data files installed in the same prefix
    mkdir -p $out/share/frog/;
    for f in ${languageMachines.frogdata}/share/frog/*; do
      ln -s $f $out/share/frog/;
    done;

    make check
  '';

  meta = with stdenv.lib; {
    description = "A Tagger-Lemmatizer-Morphological-Analyzer-Dependency-Parser for Dutch";
    homepage    = https://languagemachines.github.io/frog;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ roberth ];

    longDescription = ''
      Frog is an integration of memory-based natural language processing (NLP) modules developed for Dutch. All NLP modules are based on Timbl, the Tilburg memory-based learning software package. Most modules were created in the 1990s at the ILK Research Group (Tilburg University, the Netherlands) and the CLiPS Research Centre (University of Antwerp, Belgium). Over the years they have been integrated into a single text processing tool, which is currently maintained and developed by the Language Machines Research Group and the Centre for Language and Speech Technology at Radboud University Nijmegen. A dependency parser, a base phrase chunker, and a named-entity recognizer module were added more recently. Where possible, Frog makes use of multi-processor support to run subtasks in parallel.

      Various (re)programming rounds have been made possible through funding by NWO, the Netherlands Organisation for Scientific Research, particularly under the CGN project, the IMIX programme, the Implicit Linguistics project, the CLARIN-NL programme and the CLARIAH programme.
    '';
  };

}
