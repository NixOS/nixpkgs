#! @bash@/bin/bash
# shellcheck shell=bash

exec @emulator@ @targetgir@/bin/g-ir-compiler "$@"
