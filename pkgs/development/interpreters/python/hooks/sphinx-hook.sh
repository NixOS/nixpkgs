# This hook automatically finds Sphinx documentation, builds it in html format
# and installs it.
#
# This hook knows about several popular locations in which subdirectory
# documentation may be, but in very unusual cases $sphinxRoot directory can be
# set explicitly.
#
# Name of the directory relative to ${doc:-$out}/share/doc is normally also
# deduced automatically, but can be overridden with $sphinxOutdir variable.
#
# Sphinx build system can depend on arbitrary amount of python modules, client
# code is responsible for ensuring that all dependencies are present.

buildSphinxPhase() {
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
    sphinx-build -M html "${__sphinxRoot}" ".sphinx/html" -v

    runHook postBuildSphinx
}

installSphinxPhase() {
    local docdir=""
    runHook preInstallSphinx

    docdir="${doc:-$out}/share/doc/${sphinxOutdir:-$name}"
    mkdir -p "$docdir"

    cp -r .sphinx/html/html "$docdir/"
    rm -fr "${docdir}/html/_sources" "${docdir}/html/.buildinfo"

    runHook postInstallSphinx
}

preDistPhases+=" buildSphinxPhase"
postPhases+=" installSphinxPhase"
