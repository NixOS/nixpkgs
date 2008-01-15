source $stdenv/setup

preConfigure() {
  rm configure
  autoconf
}

preConfigure=preConfigure

installFlags='install-lib install-dev'

genericBuild
