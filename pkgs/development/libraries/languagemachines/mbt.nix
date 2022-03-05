{ lib, stdenv, fetchurl
, automake, autoconf, bzip2, libtar, libtool, pkg-config, autoconf-archive
, libxml2
, languageMachines
}:

let
  release = lib.importJSON ./release-info/LanguageMachines-mbt.json;
in

stdenv.mkDerivation {
  name = "mbt-${release.version}";
  version = release.version;
  src = fetchurl { inherit (release) url sha256;
                   name = "mbt-${release.version}.tar.gz"; };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ automake autoconf bzip2 libtar libtool autoconf-archive
                  libxml2
                  languageMachines.ticcutils
                  languageMachines.timbl
                ];
  patches = [ ./mbt-add-libxml2-dep.patch ];
  preConfigure = ''
    sh bootstrap.sh
  '';

  meta = with lib; {
    description = "Memory Based Tagger";
    homepage    = "https://languagemachines.github.io/mbt/";
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ roberth ];

    longDescription = ''
      MBT is a memory-based tagger-generator and tagger in one. The tagger-generator part can generate a sequence tagger on the basis of a training set of tagged sequences; the tagger part can tag new sequences. MBT can, for instance, be used to generate part-of-speech taggers or chunkers for natural language processing. It has also been used for named-entity recognition, information extraction in domain-specific texts, and disfluency chunking in transcribed speech.

      Mbt is used by Frog for Dutch tagging.
    '';
  };

}
