args @ { fetchurl, ... }:
{
  baseName = ''cl-markdown'';
  version = ''20101006-darcs'';

  description = '''';

  deps = [ args."anaphora" args."asdf-system-connections" args."cl-containers" args."cl-ppcre" args."dynamic-classes" args."metabang-bind" args."metatilities-base" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-markdown/2010-10-06/cl-markdown-20101006-darcs.tgz'';
    sha256 = ''1hrv7szhmhxgbadwrmf6wx4kwkbg3dnabbsz4hfffzjgprwac79w'';
  };

  packageName = "cl-markdown";

  asdFilesToKeep = ["cl-markdown.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-markdown DESCRIPTION NIL SHA256
    1hrv7szhmhxgbadwrmf6wx4kwkbg3dnabbsz4hfffzjgprwac79w URL
    http://beta.quicklisp.org/archive/cl-markdown/2010-10-06/cl-markdown-20101006-darcs.tgz
    MD5 3e748529531ad1dcbee5443fe24b6300 NAME cl-markdown FILENAME cl-markdown
    DEPS
    ((NAME anaphora FILENAME anaphora)
     (NAME asdf-system-connections FILENAME asdf-system-connections)
     (NAME cl-containers FILENAME cl-containers)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME dynamic-classes FILENAME dynamic-classes)
     (NAME metabang-bind FILENAME metabang-bind)
     (NAME metatilities-base FILENAME metatilities-base))
    DEPENDENCIES
    (anaphora asdf-system-connections cl-containers cl-ppcre dynamic-classes
     metabang-bind metatilities-base)
    VERSION 20101006-darcs SIBLINGS (cl-markdown-comparisons cl-markdown-test)
    PARASITES NIL) */
