source $stdenv/setup

configureFlags="--with-gcc=$gcc/bin/gcc"

# Don't you hate build processes that write in $HOME? :-(
export HOME=$(pwd)/fake-home
mkdir -p $HOME

genericBuild
