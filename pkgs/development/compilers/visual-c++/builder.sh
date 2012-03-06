source $stdenv/setup

mkdir -p $out

cabextract $src

mkdir tmp
cd tmp
cabextract ../vcsetup1.cab
rm ../vc* # reduce temporary disk usage a bit

while read target; do
    read source
    echo "$source -> $target"
    mkdir -p $out/$(dirname $target)
    cp -p "$source" $out/"$target"
done < $filemap

# Make DLLs and executables executable.
find $out \( -iname "*.dll" -o -iname "*.exe" -o -iname "*.config" \) -print0 | xargs -0 chmod +x

cat > $out/setup  <<EOF
export PATH="$out/VC/bin:$out/Common7/IDE:\$PATH"
export LIB="$(cygpath -w -p "$out/VC/lib")"
export INCLUDE="$(cygpath -w -p "$out/VC/include")"
EOF
