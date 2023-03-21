if [ -e .attrs.sh ]; then source .attrs.sh; fi
source $stdenv/setup

echo "exporting egg ${eggName} (version $version) into $out"

mkdir -p $out
CHICKEN_EGG_CACHE=. chicken-install -r "${eggName}:${version}"
rm ${eggName}/{STATUS,TIMESTAMP}
cp -r ${eggName}/* $out/
