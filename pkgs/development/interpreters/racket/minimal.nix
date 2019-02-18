{ racket
}:

racket.overrideAttrs (oldAttrs: rec {
  name = "racket-minimal-${oldAttrs.version}";
  src = oldAttrs.src.override {
    inherit name;
    sha256 = "01wsiyqfiiwn2n4xxk8d8di92l2ng7yhc4bfmgrvkgaqzy3zfhhx";
  };

  meta = oldAttrs.meta // {
    description = "Racket without bundled packages, such as Dr. Racket.";
    longDescription = ''The essential package racket-libs is included,
      as well as libraries that live in collections. In particular, raco
      and the pkg library are still bundled.
    '';
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    broken = false; # Minimal build does not require working FFI
  };
})
