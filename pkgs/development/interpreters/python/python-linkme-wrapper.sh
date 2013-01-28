#!/bin/sh
#
# Install it into a nix profile and from there build symlink chains.
# The chain will be followed to set the PYTHONPATH
# A/bin/foo -> B/bin/bar -> NIXENV/bin/.python-linkme-wrapper.sh
#

if test ! -L "$0"; then
   echo "Link me!"
   exit 1
fi

PROG=$(basename "$0")
SITES=

pypath() {
  BIN=$(dirname "$1")
  BIN=$(realpath -s "$BIN")
  ENV=$(dirname "$BIN")
  SITE="$ENV/lib/python2.7/site-packages"
  SITES="$SITES${SITES:+:}$SITE"

  PRG=$BIN/$(readlink "$1")

  if test -L "$PRG"; then
    pypath "$PRG"
  fi
}

pypath $(realpath -s "$0")

export PYTHONPATH="$PYTHONPATH${PYTHONPATH:+:}$SITES"

exec $BIN/$PROG "$@"
