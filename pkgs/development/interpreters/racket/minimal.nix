{ racket
}:

racket.overrideAttrs (oldAttrs: rec {
  name = "racket-minimal-${oldAttrs.version}";
  src = oldAttrs.src.override {
    inherit name;
    sha256 = "0c565jy2y3gjl5lncd5adjsrj8c24p4i062kphv26ni5q1nn5ip5";
  };

  description = "Racket without bundled packages, such as Mr Racket.";
  longDescription = ''The essential package racket-libs is included,
    as well as libraries that live in collections. In particular, raco
    and the pkg library are still bundled.
  '';

})
