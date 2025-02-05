#!/usr/bin/env bash

pushd "$(dirname "$0")" &>/dev/null || exit 1
./fetchrepo.sh && ./mkrepo.sh
popd &>/dev/null
