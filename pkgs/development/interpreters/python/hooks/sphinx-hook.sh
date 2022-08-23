# shellcheck shell=bash
echo "Sourcing sphinx-hook"

declare -a __sphinxBuilders

buildSphinxPhase() {
    echo "Executing buildSphinxPhase"

    local __sphinxRoot="" o
    runHook preBuildSphinx

    if [[ -n "${sphinxRoot:-}" ]] ; then  # explicit root
        if ! [[ -f "${sphinxRoot}/conf.py" ]] ; then
            echo 2>&1 "$sphinxRoot/conf.py: no such file"
            exit 1
        fi
        __sphinxRoot=$sphinxRoot
    else
        for o in doc docs doc/source docs/source ; do
            if [[ -f "$o/conf.py" ]] ; then
                echo "Sphinx documentation found in $o"
                __sphinxRoot=$o
                break
            fi
        done
    fi

    if [[ -z "${__sphinxRoot}" ]] ; then
        echo 2>&1 "Sphinx documentation not found, use 'sphinxRoot' variable"
        exit 1
    fi

    if [ -n "${sphinxBuilders-}" ]; then
        eval "__sphinxBuilders=($sphinxBuilders)"
    else
        __sphinxBuilders=(html)
    fi

    for __builder in "${__sphinxBuilders[@]}"; do
        echo "Executing sphinx-build with ${__builder} builder"
        sphinx-build -M "${__builder}" "${__sphinxRoot}" ".sphinx/${__builder}" -v
    done

    runHook postBuildSphinx
}

installSphinxPhase() {
    echo "Executing installSphinxPhase"

    local docdir=""
    runHook preInstallSphinx

    for __builder in "${__sphinxBuilders[@]}"; do
        # divert output for man builder
        if [ "$__builder" == "man" ]; then
            installManPage .sphinx/man/man/*

        else
            # shellcheck disable=2154
            docdir="${doc:-$out}/share/doc/${pname}"

            mkdir -p "$docdir"

            cp -r ".sphinx/${__builder}/${__builder}" "$docdir/"
            rm -fr "${docdir}/${__builder}/_sources" "${docdir}/${__builder}/.buildinfo"
        fi
    done

    runHook postInstallSphinx
}

preDistPhases+=" buildSphinxPhase"
postPhases+=" installSphinxPhase"
