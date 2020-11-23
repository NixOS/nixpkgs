{ racket
}:

racket.overrideAttrs (oldAttrs: rec {
  name = "racket-minimal-${oldAttrs.version}";
  src = oldAttrs.src.override {
    inherit name;
    sha256 = "0xvnd7afx058sg7j51bmbikqgn4sl0246nkhr8zlqcrbr3nqi6p4";
  };

  meta = oldAttrs.meta // {
    description = "Racket without bundled packages, such as Dr. Racket";
    longDescription = ''The essential package racket-libs is included,
      as well as libraries that live in collections. In particular, raco
      and the pkg library are still bundled.
    '';
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    broken = false; # Minimal build does not require working FFI
  };
})
