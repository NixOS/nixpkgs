if [ -e .attrs.sh ]; then source .attrs.sh; fi
source $stdenv/setup

echo "exporting egg ${eggName} (version $version) into $out"

mkdir -p $out
chicken-install -r "${eggName}:${version}"
cp -r ${eggName}/* $out/
