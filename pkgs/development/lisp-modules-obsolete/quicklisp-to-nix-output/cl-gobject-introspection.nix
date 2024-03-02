/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-gobject-introspection";
  version = "20210124-git";

  description = "Binding to GObjectIntrospection";

  deps = [ args."alexandria" args."babel" args."cffi" args."iterate" args."trivial-features" args."trivial-garbage" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-gobject-introspection/2021-01-24/cl-gobject-introspection-20210124-git.tgz";
    sha256 = "1hrc451d9xdp3pfmwalw32r3iqfvw6ccy665kl5560lihwmk59w0";
  };

  packageName = "cl-gobject-introspection";

  asdFilesToKeep = ["cl-gobject-introspection.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-gobject-introspection DESCRIPTION Binding to GObjectIntrospection
    SHA256 1hrc451d9xdp3pfmwalw32r3iqfvw6ccy665kl5560lihwmk59w0 URL
    http://beta.quicklisp.org/archive/cl-gobject-introspection/2021-01-24/cl-gobject-introspection-20210124-git.tgz
    MD5 ad760b820c86142c0a1309af29541680 NAME cl-gobject-introspection FILENAME
    cl-gobject-introspection DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME iterate FILENAME iterate)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage))
    DEPENDENCIES
    (alexandria babel cffi iterate trivial-features trivial-garbage) VERSION
    20210124-git SIBLINGS (cl-gobject-introspection-test) PARASITES NIL) */
