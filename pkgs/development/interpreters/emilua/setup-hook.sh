addEmiluaPath() {
  addToSearchPathWithCustomDelimiter : EMILUA_PATH $1/@sitePackages@
}

toEmiluaPath() {
    local paths="$1"
    local result=
    for i in $paths; do
        p="$i/@sitePackages@"
        result="${result}${result:+:}$p"
    done
    echo $result
}

if [ -z "${dontAddEmiluaPath:-}" ]; then
    addEnvHooks "$hostOffset" addEmiluaPath
fi
