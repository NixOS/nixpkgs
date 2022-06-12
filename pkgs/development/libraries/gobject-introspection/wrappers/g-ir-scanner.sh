#! @bash@
# shellcheck shell=bash

exec @dev@/bin/.g-ir-scanner-wrapped \
    --use-binary-wrapper=@emulator@ \
    --use-ldd-wrapper=@buildprelink@ \
    "$@"
