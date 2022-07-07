{ racket
}:

racket.overrideAttrs (oldAttrs: rec {
  pname = "racket-minimal";
  version = oldAttrs.version;
  src = oldAttrs.src.override {
    name = "${pname}-${version}";
    sha256 = "sha256-VdWF46yfuqz76ECm7HTOPnvun+heMiE/Gz5Pb1k8rjk=";
  };

  meta = oldAttrs.meta // {
    description = "Racket without bundled packages, such as Dr. Racket";
    longDescription = ''The essential package racket-libs is included,
      as well as libraries that live in collections. In particular, raco
      and the pkg library are still bundled.
    '';
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    broken = false; # Minimal build does not require working FFI
  };
})
