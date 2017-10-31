source $stdenv/setup

mkdir -p $out/xml/dtd/docbook
cd $out/xml/dtd/docbook
unpackFile $src
find . -type f -exec chmod -x {} \;
eval "$postInstall"
