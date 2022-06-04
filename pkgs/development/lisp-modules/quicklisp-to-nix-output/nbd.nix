/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "nbd";
  version = "20211020-git";

  parasites = [ "nbd/simple-in-memory" ];

  description = "Network Block Device server library.";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."closer-mop" args."flexi-streams" args."iterate" args."lisp-binary" args."moptilities" args."quasiquote-2_dot_0" args."trivial-features" args."trivial-gray-streams" args."wild-package-inferred-system" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/nbd/2021-10-20/nbd-20211020-git.tgz";
    sha256 = "1fmx5hnv2q3c4gj94vr1j7pfhh44zqgsjnxn1l5lpzkdc95hxd2y";
  };

  packageName = "nbd";

  asdFilesToKeep = ["nbd.asd"];
  overrides = x: x;
}
/* (SYSTEM nbd DESCRIPTION Network Block Device server library. SHA256
    1fmx5hnv2q3c4gj94vr1j7pfhh44zqgsjnxn1l5lpzkdc95hxd2y URL
    http://beta.quicklisp.org/archive/nbd/2021-10-20/nbd-20211020-git.tgz MD5
    9f5755497817a667537f5bbcde153512 NAME nbd FILENAME nbd DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME closer-mop FILENAME closer-mop)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate) (NAME lisp-binary FILENAME lisp-binary)
     (NAME moptilities FILENAME moptilities)
     (NAME quasiquote-2.0 FILENAME quasiquote-2_dot_0)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME wild-package-inferred-system FILENAME wild-package-inferred-system))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi closer-mop flexi-streams iterate
     lisp-binary moptilities quasiquote-2.0 trivial-features
     trivial-gray-streams wild-package-inferred-system)
    VERSION 20211020-git SIBLINGS NIL PARASITES (nbd/simple-in-memory)) */
