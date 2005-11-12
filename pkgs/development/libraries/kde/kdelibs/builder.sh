source $stdenv/setup

configureFlags="\
  --without-arts \
  --with-ssl-dir=$openssl \
  --with-extra-includes=$libjpeg/include \
  --x-includes=$libX11/include \
  --x-libraries=$libX11/lib"

genericBuild
