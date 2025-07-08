#!/usr/bin/env bash

ELS_MODE=language_server
export ELS_MODE

# In case that people want to tweak the path, which Elixir to use, or
# whatever prior to launching the language server or the debug adapter, we
# give them the chance here. ELS_MODE will be set for
# the really complex stuff. Use an XDG compliant path.

els_setup="${XDG_CONFIG_HOME:-$HOME/.config}/elixir_ls/setup.sh"
if test -f "${els_setup}"; then
  >&2 echo "Running setup script $els_setup"
  # shellcheck disable=SC1090
  . "${els_setup}"
fi

# Setup done. Make sure that we have the proper actual path to this
# script so we can correctly configure the Erlang library path to
# include the local .ez files, and then do what we were asked to do.

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")/../lib

export MIX_ENV=prod
# Mix.install prints to stdout and reads from stdin
# we need to make sure it doesn't interfere with LSP/DAP
echo "" | @elixir@/bin/elixir "$SCRIPTPATH/quiet_install.exs" >/dev/null || exit 1

default_erl_opts="-kernel standard_io_encoding latin1 +sbwt none +sbwtdcpu none +sbwtdio none"

ELX_STDLIB_PATH=${ELX_STDLIB_PATH:-@elixir@/lib/elixir}
export ELX_STDLIB_PATH

# we need to make sure ELS_ELIXIR_OPTS gets splitted by word
# parse it as bash array
# shellcheck disable=SC3045
# shellcheck disable=SC3011
IFS=' ' read -ra elixir_opts <<<"$ELS_ELIXIR_OPTS"
# shellcheck disable=SC3054
# shellcheck disable=SC2068
exec @elixir@/bin/elixir ${elixir_opts[@]} --erl "$default_erl_opts $ELS_ERL_OPTS" "$SCRIPTPATH/launch.exs"
