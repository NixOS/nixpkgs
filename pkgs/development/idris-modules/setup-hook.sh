# Library import path
export IDRIS_LIBRARY_PATH=$PWD/idris-libs
mkdir -p $IDRIS_LIBRARY_PATH

# Library install path
export IBCSUBDIR=$out/lib/@name@
mkdir -p $IBCSUBDIR

addIdrisLibs () {
  if [ -d $1/lib/@name@ ]; then
    ln -sv $1/lib/@name@/* $IDRIS_LIBRARY_PATH
  fi
}

# All run-time deps
addEnvHooks 1 addIdrisLibs
