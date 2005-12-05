source $stdenv/setup

export DYLANDIR=$dylan
export DYLANPATH=$dylan/lib/dylan/2.4.0/x86-linux-gcc
configureFlags="--with-existing-runtime=$dylan/lib/dylan/2.4.0/x86-linux-gcc"
export LD_LIBRARY_PATH="$dylan/lib/dylan/2.4.0/x86-linux-gcc:$LD_LIBRARY_PATH:$boehmgc/lib"

genericBuild
