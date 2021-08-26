/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-l10n-cldr";
  version = "20120909-darcs";

  description = "The necessary CLDR files for cl-l10n packaged in a QuickLisp friendly way.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-l10n-cldr/2012-09-09/cl-l10n-cldr-20120909-darcs.tgz";
    sha256 = "03l81bx8izvzwzw0qah34l4k47l4gmhr917phhhl81qp55x7zbiv";
  };

  packageName = "cl-l10n-cldr";

  asdFilesToKeep = ["cl-l10n-cldr.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-l10n-cldr DESCRIPTION
    The necessary CLDR files for cl-l10n packaged in a QuickLisp friendly way.
    SHA256 03l81bx8izvzwzw0qah34l4k47l4gmhr917phhhl81qp55x7zbiv URL
    http://beta.quicklisp.org/archive/cl-l10n-cldr/2012-09-09/cl-l10n-cldr-20120909-darcs.tgz
    MD5 466e776f2f6b931d9863e1fc4d0b514e NAME cl-l10n-cldr FILENAME
    cl-l10n-cldr DEPS NIL DEPENDENCIES NIL VERSION 20120909-darcs SIBLINGS NIL
    PARASITES NIL) */
