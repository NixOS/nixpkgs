# Expose solo5 findlib config for
# `ocamlfind -toolchain solo5`
# dune setup with solo5 toolchain
# etc.

# dune installs packages built in a toolchain context under
# <libdir>/../solo5-sysroot/lib
# collect them from build inputs
addSolo5Sysroot() {
    local d
    for d in "$1"/lib/ocaml/*/solo5-sysroot/lib; do
        if [ -d "$d" ]; then
            solo5Sysroots="${solo5Sysroots-}${solo5Sysroots:+:}$d"
        fi
    done
}

addEnvHooks "$targetOffset" addSolo5Sysroot

exportSolo5FindlibConf() {
    command -v ocamlfind >/dev/null || return 0

    local confdir baseconf
    baseconf="${OCAMLFIND_CONF:-$(ocamlfind printconf conf 2>/dev/null)}"
    [ -e "$baseconf" ] || return 0

    confdir="$(mktemp -d)"
    mkdir -p "$confdir/findlib.conf.d"
    cat "$baseconf" > "$confdir/findlib.conf"
    cp "${baseconf%/*}/findlib.conf.d/"*.conf "$confdir/findlib.conf.d/" 2>/dev/null || true

    # sysroots before OCAMLPATH so target builds shadow host builds
    sed -e "s|^path(solo5) = \"\(.*\)\"|path(solo5) = \"\1${solo5Sysroots:+:${solo5Sysroots}}${OCAMLPATH:+:${OCAMLPATH%:}}\"|" \
        "@out@/lib/findlib.conf.d/solo5.conf" \
        > "$confdir/findlib.conf.d/solo5.conf"

    export OCAMLFIND_CONF="$confdir/findlib.conf"
}

postHooks+=(exportSolo5FindlibConf)
