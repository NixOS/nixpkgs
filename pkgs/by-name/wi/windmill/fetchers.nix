# not a stable interface, do not reference outside the windmill package but make a copy if you need
{
  lib,
  stdenv,
  fetchurl,
}:

{
  fetchLibrustyV8 =
    args:
    fetchurl {
      name = "librusty_v8-${args.version}";
      # The `deno` crates enable the `simdutf` feature of `v8`. That feature
      # needs the archive that has `simdutf`.
      url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_simdutf_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
      sha256 = args.shas.${stdenv.hostPlatform.system};
      meta = {
        inherit (args) version;
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      };
    };
}
