addStackArgs () {
  if [ -n "$(echo $1/lib/lib*)" ]; then
    STACK_IN_NIX_EXTRA_ARGS+=" --extra-lib-dirs=$1/lib"
  fi

  if [ -d "$1/include" ]; then
    STACK_IN_NIX_EXTRA_ARGS+=" --extra-include-dirs=$1/include"
  fi
}

addEnvHooks "$targetOffset" addStackArgs
