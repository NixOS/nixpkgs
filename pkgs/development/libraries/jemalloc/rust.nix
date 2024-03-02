{ lib
, stdenv
, jemalloc
, writeText

, unprefixed ? false
}:

let
  # On some platforms the unprefixed feature will be ignored:
  # https://github.com/tikv/jemallocator/blob/ab0676d77e81268cd09b059260c75b38dbef2d51/jemalloc-sys/src/env.rs
  unprefixed' = unprefixed && !stdenv.hostPlatform.isMusl && !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isAndroid;

in jemalloc.overrideAttrs (oldAttrs: {
  configureFlags = oldAttrs.configureFlags ++ [
    "--with-private-namespace=_rjem_"
  ] ++ lib.optionals (!unprefixed') [
    "--with-jemalloc-prefix=_rjem_"
  ];

  setupHook = writeText "setup-hook.sh" ''
    export JEMALLOC_OVERRIDE="@out@/lib/libjemalloc${stdenv.hostPlatform.extensions.library}"
  '';
})
