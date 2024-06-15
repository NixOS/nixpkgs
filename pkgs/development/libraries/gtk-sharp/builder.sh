if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; elif [ -f .attrs.sh ]; then . .attrs.sh; fi
source $stdenv/setup

genericBuild

# !!! hack
export ALL_INPUTS="$out $pkgs"

find $out -name "*.dll.config" | while read configFile; do
    echo "modifying config file $configFile"
    $monoDLLFixer "$configFile"
done
