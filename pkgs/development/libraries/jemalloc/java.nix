{
  lib,
  stdenv,
  jemalloc,
  unprefixed ? false,
}:

jemalloc.overrideAttrs (oldAttrs: {
  configureFlags =
    oldAttrs.configureFlags
    ++ [
      "--with-private-namespace=je_"
    ]
    ++ lib.optionals (!unprefixed) [
      "--with-jemalloc-prefix=je_"
    ];
})
