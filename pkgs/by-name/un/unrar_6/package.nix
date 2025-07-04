{
  unrar,
  fetchzip,
}:

unrar.overrideAttrs (
  finalAttrs: _: {
    version = "6.2.12";

    src = fetchzip {
      url = "https://www.rarlab.com/rar/unrarsrc-${finalAttrs.version}.tar.gz";
      stripRoot = false;
      hash = "sha256-VAL3o9JGmkAcEssa/P/SL9nyxnigb7dX9YZBHrG9f0A=";
    };

    sourceRoot = finalAttrs.src.name;
  }
)
