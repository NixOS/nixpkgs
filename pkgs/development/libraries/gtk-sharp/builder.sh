. $stdenv/setup

genericBuild

# !!! hack
export ALL_INPUTS=$pkgs

find $out -name "*.dll.config" | while read configFile; do
    echo "modifying config file $configFile"
    $monoDLLFixer "$configFile"
done
