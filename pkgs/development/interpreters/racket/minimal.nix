{ racket
}:

racket.overrideAttrs (oldAttrs: rec {
  pname = "racket-minimal";
  version = oldAttrs.version;
  src = oldAttrs.src.override {
    name = "${pname}-${version}";
    hash = "sha256-H1X9bhQw9yOaESbK4+tveFWVb4EyMNGLKukwKAo588w=";
  };

  meta = oldAttrs.meta // {
    description = "Racket without bundled packages, such as Dr. Racket";
    longDescription = ''The essential package racket-libs is included,
      as well as libraries that live in collections. In particular, raco
      and the pkg library are still bundled.
    '';
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
})
