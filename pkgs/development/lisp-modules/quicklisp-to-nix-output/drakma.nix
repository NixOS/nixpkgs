args @ { fetchurl, ... }:
rec {
  baseName = ''drakma'';
  version = ''v2.0.7'';

  description = ''Full-featured http/https client based on usocket'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."chipz" args."chunga" args."cl_plus_ssl" args."cl-base64" args."cl-ppcre" args."flexi-streams" args."puri" args."split-sequence" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/drakma/2019-11-30/drakma-v2.0.7.tgz'';
    sha256 = ''1r0sh0nsx7fq24yybazjw8n7grk1b85l52x523axwchnnaj58kzw'';
  };

  packageName = "drakma";

  asdFilesToKeep = ["drakma.asd"];
  overrides = x: x;
}
/* (SYSTEM drakma DESCRIPTION Full-featured http/https client based on usocket
    SHA256 1r0sh0nsx7fq24yybazjw8n7grk1b85l52x523axwchnnaj58kzw URL
    http://beta.quicklisp.org/archive/drakma/2019-11-30/drakma-v2.0.7.tgz MD5
    f166498aaed67f726060e9e997df10a3 NAME drakma FILENAME drakma DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME chipz FILENAME chipz)
     (NAME chunga FILENAME chunga) (NAME cl+ssl FILENAME cl_plus_ssl)
     (NAME cl-base64 FILENAME cl-base64) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME flexi-streams FILENAME flexi-streams) (NAME puri FILENAME puri)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi chipz chunga cl+ssl cl-base64
     cl-ppcre flexi-streams puri split-sequence trivial-features
     trivial-garbage trivial-gray-streams usocket)
    VERSION v2.0.7 SIBLINGS (drakma-test) PARASITES NIL) */
