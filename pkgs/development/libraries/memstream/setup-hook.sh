useMemstream () {
  export NIX_CFLAGS_COMPILE="${NIX_CFLAGS_COMPILE-}${NIX_CFLAGS_COMPILE:+ }-include memstream.h";
  export NIX_LDFLAGS="${NIX_LDFLAGS-}${NIX_LDFLAGS:+ }-lmemstream";
}

postHooks+=(useMemstream)
