/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-xmlspam";
  version = "20101006-http";

  description = "Streaming pattern matching for XML";

  deps = [ args."alexandria" args."babel" args."cl-ppcre" args."closure-common" args."cxml" args."puri" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-xmlspam/2010-10-06/cl-xmlspam-20101006-http.tgz";
    sha256 = "1mx1a6ab4irncrx5pamh7zng35m4c5wh0pw68avaz7fbz81s953h";
  };

  packageName = "cl-xmlspam";

  asdFilesToKeep = ["cl-xmlspam.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-xmlspam DESCRIPTION Streaming pattern matching for XML SHA256
    1mx1a6ab4irncrx5pamh7zng35m4c5wh0pw68avaz7fbz81s953h URL
    http://beta.quicklisp.org/archive/cl-xmlspam/2010-10-06/cl-xmlspam-20101006-http.tgz
    MD5 6e3a0944e96e17916b1445f4207babb8 NAME cl-xmlspam FILENAME cl-xmlspam
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME closure-common FILENAME closure-common) (NAME cxml FILENAME cxml)
     (NAME puri FILENAME puri)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES
    (alexandria babel cl-ppcre closure-common cxml puri trivial-features
     trivial-gray-streams)
    VERSION 20101006-http SIBLINGS NIL PARASITES NIL) */
