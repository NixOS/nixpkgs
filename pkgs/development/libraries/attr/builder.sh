source $stdenv/setup

preConfigure() {
  autoconf
}

preConfigure=preConfigure

installFlags='install-lib install-dev'

genericBuild
