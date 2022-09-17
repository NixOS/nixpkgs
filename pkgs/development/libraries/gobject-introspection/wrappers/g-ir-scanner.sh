#! @bash@/bin/bash
# shellcheck shell=bash

exec @dev@/bin/.g-ir-scanner-wrapped \
    --use-binary-wrapper=@emulator@ \
    --use-ldd-wrapper=@dev@/bin/g-ir-scanner-lddwrapper \
    "$@"
