# Expose solo5 findlib config for
# `ocamlfind -toolchain solo5`
# dune setup with solo5 toolchain
# etc.

exportSolo5FindlibConf() {
    command -v ocamlfind >/dev/null || return 0

    local confdir baseconf
    baseconf="${OCAMLFIND_CONF:-$(ocamlfind printconf conf 2>/dev/null)}"
    [ -e "$baseconf" ] || return 0

    confdir="$(mktemp -d)"
    mkdir -p "$confdir/findlib.conf.d"
    cat "$baseconf" > "$confdir/findlib.conf"
    cp "${baseconf%/*}/findlib.conf.d/"*.conf "$confdir/findlib.conf.d/" 2>/dev/null || true

    sed -e "s|^path(solo5) = \"\(.*\)\"|path(solo5) = \"\1${OCAMLPATH:+:${OCAMLPATH%:}}\"|" \
        "@out@/lib/findlib.conf.d/solo5.conf" \
        > "$confdir/findlib.conf.d/solo5.conf"

    export OCAMLFIND_CONF="$confdir/findlib.conf"
}

postHooks+=(exportSolo5FindlibConf)
