if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; elif [ -f .attrs.sh ]; then . .attrs.sh; fi
source $stdenv/setup

echo "exporting egg ${eggName} (version $version) into $out"

mkdir -p $out
chicken-install -r "${eggName}:${version}"
cp -r ${eggName}/* $out/
