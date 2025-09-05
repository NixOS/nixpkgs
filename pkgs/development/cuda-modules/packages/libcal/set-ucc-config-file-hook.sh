# shellcheck shell=bash

if (("${cudaDontSetUccConfigFile:-0}" == 0)); then
  nixLog "sourcing set-ucc-config-file-hook.sh"
else
  return 0
fi

declare -ig cudaDontSetUccConfigFile=1

# The UCC_CONFIG_FILE environment variable is used by the UCC library to locate the configuration file. The default
# location is share/ucc.conf, one level above the location `libcal`'s shared libraries are installed. We need to set
# this environment variable to the output which actually holds the configuration file -- `out`.
export UCC_CONFIG_FILE="@out@/share/ucc.conf"
nixLog "set UCC_CONFIG_FILE to $UCC_CONFIG_FILE"
