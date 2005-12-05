addInputsHook=addBzip2
addBzip2() {
    bzip2=$(type -tP bzip2)
    test -n $bzip2 || fail
    buildInputs="$(dirname $(dirname $bzip2)) $buildInputs"
}

source $stdenv/setup

genericBuild