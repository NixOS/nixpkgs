source $stdenv/setup

mkdir -p $out/share/xml/dtd/docbook
cd $out/share/xml/dtd/docbook
# The symlink is for compatibility and should be removed when derivations refer to
# share/xml instead of xml
ln -s $out/share/xml $out/xml
unpackFile $src
find . -type f -exec chmod -x {} \;
eval "$postInstall"
