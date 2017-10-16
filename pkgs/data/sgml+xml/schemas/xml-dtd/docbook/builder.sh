source $stdenv/setup

dir=$out/share/${stdenv.lib.replaceStrings [ "-xml" ] [ "" ] name}/dtd
mkdir -p $dir
cd $dir
unpackFile $src
find . -type f -exec chmod -x {} \;
eval "$postInstall"
