/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "eager-future2";
  version = "20191130-git";

  description = "Parallel programming library providing the futures/promises synchronization mechanism";

  deps = [ args."alexandria" args."bordeaux-threads" args."trivial-garbage" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/eager-future2/2019-11-30/eager-future2-20191130-git.tgz";
    sha256 = "01pvgcp6d4hz1arpvsv73m8xnbv8qm2d0qychpxc72d0m71p6ks0";
  };

  packageName = "eager-future2";

  asdFilesToKeep = ["eager-future2.asd"];
  overrides = x: x;
}
/* (SYSTEM eager-future2 DESCRIPTION
    Parallel programming library providing the futures/promises synchronization mechanism
    SHA256 01pvgcp6d4hz1arpvsv73m8xnbv8qm2d0qychpxc72d0m71p6ks0 URL
    http://beta.quicklisp.org/archive/eager-future2/2019-11-30/eager-future2-20191130-git.tgz
    MD5 72298620b0fb2f874d86d887cce4acf0 NAME eager-future2 FILENAME
    eager-future2 DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME trivial-garbage FILENAME trivial-garbage))
    DEPENDENCIES (alexandria bordeaux-threads trivial-garbage) VERSION
    20191130-git SIBLINGS (test.eager-future2) PARASITES NIL) */
