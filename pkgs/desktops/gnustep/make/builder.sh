if [ -e .attrs.sh ]; then source .attrs.sh; fi
source $stdenv/setup

preConfigure() {
    . $GNUSTEP_MAKEFILES/GNUstep.sh
}

wrapGSMake() {
    local program="$1"
    local config="$2"
    local wrapped="$(dirname $program)/.$(basename $program)-wrapped"

    mv "$program" "$wrapped"

    cat > "$program"<<EOF
#! $SHELL -e

export GNUSTEP_CONFIG_FILE="$config"

exec "$wrapped" "\$@"
EOF
    chmod +x "$program"
}

postInstall() {
    local conf="$out/share/.GNUstep.conf"

    mkdir -p "$out/share"
    touch $conf

    # add the current package to the paths
    local tmp="$out/lib/GNUstep/Applications"
    if [ -d "$tmp" ] && case "$NIX_GNUSTEP_SYSTEM_APPS" in *"${tmp}"*) false;; *) true;; esac; then
        addToSearchPath NIX_GNUSTEP_SYSTEM_APPS "$tmp"
    fi
    tmp="$out/lib/GNUstep/Applications"
    if [ -d "$tmp" ] && case "$NIX_GNUSTEP_SYSTEM_ADMIN_APPS" in *"${tmp}"*) false;; *) true;; esac; then
        addToSearchPath NIX_GNUSTEP_SYSTEM_ADMIN_APPS "$tmp"
    fi
    tmp="$out/lib/GNUstep/WebApplications"
    if [ -d "$tmp" ] && case "$NIX_GNUSTEP_SYSTEM_WEB_APPS" in *"${tmp}"*) false;; *) true;; esac; then
        addToSearchPath NIX_GNUSTEP_SYSTEM_WEB_APPS "$tmp"
    fi
    tmp="$out/bin"
    if [ -d "$tmp" ] && case "$NIX_GNUSTEP_SYSTEM_TOOLS" in *"${tmp}"*) false;; *) true;; esac; then
        addToSearchPath NIX_GNUSTEP_SYSTEM_TOOLS "$tmp"
    fi
    tmp="$out/sbin"
    if [ -d "$tmp" ] && case "$NIX_GNUSTEP_SYSTEM_ADMIN_TOOLS" in *"${tmp}"*) false;; *) true;; esac; then
        addToSearchPath NIX_GNUSTEP_SYSTEM_ADMIN_TOOLS "$tmp"
    fi
    tmp="$out/lib/GNUstep"
    if [ -d "$tmp" ] && case "$NIX_GNUSTEP_SYSTEM_LIBRARY" in *"${tmp}"*) false;; *) true;; esac; then
            addToSearchPath NIX_GNUSTEP_SYSTEM_LIBRARY "$tmp"
    fi
    tmp="$out/include"
    if [ -d "$tmp" ] && case "$NIX_GNUSTEP_SYSTEM_HEADERS" in *"${tmp}"*) false;; *) true;; esac; then
            if [ -z "$NIX_GNUSTEP_SYSTEM_HEADERS" ]; then
                export NIX_GNUSTEP_SYSTEM_HEADERS="$tmp"
            else
                export NIX_GNUSTEP_SYSTEM_HEADERS+=" $tmp"
            fi
    fi
    tmp="$out/lib"
    if [ -d "$tmp" ] && case "$NIX_GNUSTEP_SYSTEM_LIBRARIES" in *"${tmp}"*) false;; *) true;; esac; then
        addToSearchPath NIX_GNUSTEP_SYSTEM_LIBRARIES "$tmp"
    fi
    tmp="$out/share/GNUstep/Documentation"
    if [ -d "$tmp" ] && case "$NIX_GNUSTEP_SYSTEM_DOC" in *"${tmp}"*) false;; *) true;; esac; then
        addToSearchPath NIX_GNUSTEP_SYSTEM_DOC "$tmp"
    fi
    tmp="$out/share/man"
    if [ -d "$tmp" ] && case "$NIX_GNUSTEP_SYSTEM_DOC_MAN" in *"${tmp}"*) false;; *) true;; esac; then
        addToSearchPath NIX_GNUSTEP_SYSTEM_DOC_MAN "$tmp"
    fi
    tmp="$out/share/info"
    if [ -d "$tmp" ] && case "$NIX_GNUSTEP_SYSTEM_DOC_INFO" in *"${tmp}"*) false;; *) true;; esac; then
        addToSearchPath NIX_GNUSTEP_SYSTEM_DOC_INFO "$tmp"
    fi

    # write the config file
    echo GNUSTEP_MAKEFILES=$GNUSTEP_MAKEFILES >> $conf
    if [ -n "$NIX_GNUSTEP_SYSTEM_APPS" ]; then
        echo NIX_GNUSTEP_SYSTEM_APPS="$NIX_GNUSTEP_SYSTEM_APPS"
    fi
    if [ -n "$NIX_GNUSTEP_SYSTEM_ADMIN_APPS" ]; then
        echo NIX_GNUSTEP_SYSTEM_ADMIN_APPS="$NIX_GNUSTEP_SYSTEM_ADMIN_APPS" >> $conf
    fi
    if [ -n "$NIX_GNUSTEP_SYSTEM_WEB_APPS" ]; then
        echo NIX_GNUSTEP_SYSTEM_WEB_APPS="$NIX_GNUSTEP_SYSTEM_WEB_APPS" >> $conf
    fi
    if [ -n "$NIX_GNUSTEP_SYSTEM_TOOLS" ]; then
        echo NIX_GNUSTEP_SYSTEM_TOOLS="$NIX_GNUSTEP_SYSTEM_TOOLS" >> $conf
    fi
    if [ -n "$NIX_GNUSTEP_SYSTEM_ADMIN_TOOLS" ]; then
        echo NIX_GNUSTEP_SYSTEM_ADMIN_TOOLS="$NIX_GNUSTEP_SYSTEM_ADMIN_TOOLS" >> $conf
    fi
    if [ -n "$NIX_GNUSTEP_SYSTEM_LIBRARY" ]; then
        echo NIX_GNUSTEP_SYSTEM_LIBRARY="$NIX_GNUSTEP_SYSTEM_LIBRARY" >> $conf
    fi
    if [ -n "$NIX_GNUSTEP_SYSTEM_HEADERS" ]; then
        echo NIX_GNUSTEP_SYSTEM_HEADERS="$NIX_GNUSTEP_SYSTEM_HEADERS" >> $conf
    fi
    if [ -n "$NIX_GNUSTEP_SYSTEM_LIBRARIES" ]; then
        echo NIX_GNUSTEP_SYSTEM_LIBRARIES="$NIX_GNUSTEP_SYSTEM_LIBRARIES" >> $conf
    fi
    if [ -n "$NIX_GNUSTEP_SYSTEM_DOC" ]; then
        echo NIX_GNUSTEP_SYSTEM_DOC="$NIX_GNUSTEP_SYSTEM_DOC" >> $conf
    fi
    if [ -n "$NIX_GNUSTEP_SYSTEM_DOC_MAN" ]; then
        echo NIX_GNUSTEP_SYSTEM_DOC_MAN="$NIX_GNUSTEP_SYSTEM_DOC_MAN" >> $conf
    fi
    if [ -n "$NIX_GNUSTEP_SYSTEM_DOC_INFO" ]; then
        echo NIX_GNUSTEP_SYSTEM_DOC_INFO="$NIX_GNUSTEP_SYSTEM_DOC_INFO" >> $conf
    fi

    for i in $out/bin/*; do
        echo "wrapping $(basename $i)"
        wrapGSMake "$i" "$out/share/.GNUstep.conf"
    done
}

genericBuild
