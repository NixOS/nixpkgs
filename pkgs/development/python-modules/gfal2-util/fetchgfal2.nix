{
  lib,
  runCommandLocal,
  gfal2-util,
}:

# `url` and `urls` should only be overridden via `<pkg>.override`, but not `<pkg>.overrideAttrs`.
{
  name ? "",
  pname ? "",
  version ? "",
  urls ? [ ],
  url ? if urls == [ ] then abort "Expect either non-empty `urls` or `url`" else lib.head urls,
  hash ? lib.fakeHash,
  recursive ? false,
  intermediateDestUrls ? [ ],
  extraGfalCopyFlags ? [ ],
  allowSubstitutes ? true,
}:

(runCommandLocal name { } ''
  for u in "''${urls[@]}"; do
    gfal-copy "''${gfalCopyFlags[@]}" "$u" "''${intermediateDestUrls[@]}" "$out"
    ret="$?"
    (( ret )) && break
  done
  if (( ret )); then
    echo "gfal-copy failed trying to download from any of the urls" >&2
    exit "$ret"
  fi
'').overrideAttrs
  (
    finalAttrs: previousAttrs:
    {
      __structuredAttrs = true;
      inherit allowSubstitutes;
      nativeBuildInputs = [ gfal2-util ];
      outputHashAlgo = null;
      outputHashMode = if finalAttrs.recursive then "recursive" else "flat";
      outputHash = hash;
      inherit url;
      urls = if urls == [ ] then lib.singleton url else urls;
      gfalCopyFlags = extraGfalCopyFlags ++ lib.optional finalAttrs.recursive "--recursive";
      inherit recursive intermediateDestUrls;
    }
    // (
      if (pname != "" && version != "") then
        {
          inherit pname version;
          name = "${finalAttrs.pname}-${finalAttrs.version}";
        }
      else
        { name = if (name != "") then name else (baseNameOf url); }
    )
  )
