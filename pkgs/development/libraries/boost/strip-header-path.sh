postPhases+=" boostHeaderStripPhase"

boostHeaderStripPhase() {
    runHook preBoostHeaderStrip
    [ -z "$outputs" ] && outputs=out
    for output in $outputs; do
      eval "path=\$$outputs"
      [ -d "$path/bin" ] || continue
      find "$path/bin" -type f -exec sed -i "s,[^/]*\(-boost-[0-9.]*-dev\),xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\1,g" {} \;
    done
    runHook postBoostHeaderStrip
}
