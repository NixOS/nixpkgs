source $stdenv/setup

mkdir -p $out

n=1
for p in $srcs; do
    ln -s $p PSDK-FULL.$n.cab
    n=$((n + 1))
done

mkdir tmp
cd tmp
cabextract ../PSDK-FULL.1.cab

mkdir tmp
cd tmp
for i in ../Setup/*.cab; do
    cabextract $i
done

while read target; do
    read source
    echo "$source -> $target"
    mkdir -p "$out/$(dirname "$target")"
    cp "$source" "$out/$target"
done < $filemap

# Make DLLs and executables executable.
find $out \( -iname "*.dll" -o -iname "*.exe" -o -iname "*.config" \) -print0 | xargs -0 chmod +x

cat > $out/setup  <<EOF
export PATH="$out/bin:\$PATH"
export LIB="$(cygpath -w -p "$out/lib");\$LIB"
export INCLUDE="$(cygpath -w -p "$out/include");\$INCLUDE"
EOF
