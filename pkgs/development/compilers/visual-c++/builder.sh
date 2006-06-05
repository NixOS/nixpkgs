source $stdenv/setup

ensureDir $out

cabextract $src

mkdir tmp
cd tmp
cabextract ../vcsetup1.cab
rm ../vc* # reduce temporary disk usage a bit

while read target; do
    read source
    echo "$source -> $target"
    ensureDir $out/$(dirname $target)
    cp "$source" $out/"$target"
done < $filemap

cat > $out/setup  <<EOF
export PATH="$out/VC/bin:$out/Common7/IDE:$sdkPath/bin:\$PATH"
export LIB="$(cygpath -w -p "$out/VC/lib:$sdkPath/lib")"
export INCLUDE="$(cygpath -w -p "$out/VC/include:$sdkPath/include")"
EOF
