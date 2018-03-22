args @ { fetchurl, ... }:
rec {
  baseName = ''lquery'';
  version = ''20180131-git'';

  description = ''A library to allow jQuery-like HTML/DOM manipulation.'';

  deps = [ args."array-utils" args."clss" args."documentation-utils" args."form-fiddle" args."plump" args."trivial-indent" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lquery/2018-01-31/lquery-20180131-git.tgz'';
    sha256 = ''1v5mmdx7a1ngydkcs3c5anmqrl0jxc52b8jisc2f0b5k0j1kgmm9'';
  };

  packageName = "lquery";

  asdFilesToKeep = ["lquery.asd"];
  overrides = x: x;
}
/* (SYSTEM lquery DESCRIPTION
    A library to allow jQuery-like HTML/DOM manipulation. SHA256
    1v5mmdx7a1ngydkcs3c5anmqrl0jxc52b8jisc2f0b5k0j1kgmm9 URL
    http://beta.quicklisp.org/archive/lquery/2018-01-31/lquery-20180131-git.tgz
    MD5 07e92aad32c4d12c4699956b57dbc9b8 NAME lquery FILENAME lquery DEPS
    ((NAME array-utils FILENAME array-utils) (NAME clss FILENAME clss)
     (NAME documentation-utils FILENAME documentation-utils)
     (NAME form-fiddle FILENAME form-fiddle) (NAME plump FILENAME plump)
     (NAME trivial-indent FILENAME trivial-indent))
    DEPENDENCIES
    (array-utils clss documentation-utils form-fiddle plump trivial-indent)
    VERSION 20180131-git SIBLINGS (lquery-test) PARASITES NIL) */
