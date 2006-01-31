# Ugh, this should be factored out.
addInputsHook=addBzip2
addBzip2() {
    bzip2=$(type -tP bzip2)
    test -n $bzip2 || fail
    buildInputs="$(dirname $(dirname $bzip2)) $buildInputs"
}

source $stdenv/setup

configureFlags="\
  --without-arts \
  --with-ssl-dir=$openssl \
  --with-extra-includes=$libjpeg/include \
  --x-includes=$libX11/include \
  --x-libraries=$libX11/lib"

genericBuild
