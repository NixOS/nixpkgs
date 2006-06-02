source $stdenv/setup

ensureDir $out
cat > $out/setup  <<EOF
export PATH="$vs8Path/VC/bin:$vs8Path/Common7/IDE:$sdkPath/bin:$PATH"
export LIB="$(cygpath -w -p "$vs8Path/VC/lib:$sdkPath/lib")"
export INCLUDE="$(cygpath -w -p "$sdkPath/include:$sdkPath/include/crt")"
EOF
