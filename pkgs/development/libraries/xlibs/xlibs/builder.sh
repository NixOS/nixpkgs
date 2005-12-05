source $stdenv/setup
dontBuild=1
dontMakeInstall=1
nop() {
    sourceRoot=.
}
unpackPhase=nop
genericBuild
