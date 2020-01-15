args @ { fetchurl, ... }:
{
  baseName = ''static-vectors'';
  version = ''v1.8.3'';

  parasites = [ "static-vectors/test" ];

  description = ''Create vectors allocated in static memory.'';

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."fiveam" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/static-vectors/2017-10-19/static-vectors-v1.8.3.tgz'';
    sha256 = ''084690v6xldb9xysgc4hg284j0j9ppxldz4gxwmfin1dzxq0g6xk'';
  };

  packageName = "static-vectors";

  asdFilesToKeep = ["static-vectors.asd"];
  overrides = x: x;
}
/* (SYSTEM static-vectors DESCRIPTION
    Create vectors allocated in static memory. SHA256
    084690v6xldb9xysgc4hg284j0j9ppxldz4gxwmfin1dzxq0g6xk URL
    http://beta.quicklisp.org/archive/static-vectors/2017-10-19/static-vectors-v1.8.3.tgz
    MD5 cbad9e34904eedde61cd4cddcca6de29 NAME static-vectors FILENAME
    static-vectors DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME fiveam FILENAME fiveam)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain fiveam trivial-features)
    VERSION v1.8.3 SIBLINGS NIL PARASITES (static-vectors/test)) */
