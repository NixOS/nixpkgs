#! /bin/sh -e

. $stdenv/setup

mkdir $out
mkdir $out/bin
for i in $(cd $gcc/bin && ls); do
  cat > $out/bin/$i <<EOF
#! /bin/sh

_NIX_CFLAGS_COMPILE="-B$glibc/lib -isystem $glibc/include $NIX_CFLAGS_COMPILE"
_NIX_CFLAGS_LINK="-L$glibc/lib -L$gcc/lib $NIX_CFLAGS_LINK"
_NIX_LDFLAGS="-dynamic-linker $glibc/lib/ld-linux.so.2 -rpath $glibc/lib -rpath $gcc/lib $NIX_LDFLAGS"
  
IFS=

justcompile=0
if test "\$*" = "-v"; then
    justcompile=1
else    
    for i in \$@; do
        if test "\$i" == "-c"; then
            justcompile=1
        elif test "\$i" == "-S"; then
            justcompile=1
        elif test "\$i" == "-E"; then
            justcompile=1
        elif test "\$i" == "-E"; then
            justcompile=1
        elif test "\$i" == "-M"; then
            justcompile=1
        elif test "\$i" == "-MM"; then
            justcompile=1
        fi
    done
fi

IFS=" "
extra=(\$_NIX_CFLAGS_COMPILE)
if test "\$justcompile" != "1"; then
    extra=(\${extra[@]} \$_NIX_CFLAGS_LINK)
    for i in \$_NIX_LDFLAGS; do
        extra=(\${extra[@]} "-Wl,\$i")
    done
    if test "\$_NIX_STRIP_DEBUG" == "1"; then
        extra=(\${extra[@]} -g0 -Wl,-s)
    fi
fi

if test "\$NIX_DEBUG" == "1"; then
  echo "extra flags to @GCC@:" >&2
  for i in \${extra[@]}; do
      echo "  \$i" >&2
  done
fi

IFS=

exec $gcc/bin/$i \$@ \${extra[@]}
EOF
  chmod +x $out/bin/$i
done

echo $gcc > $out/orig-gcc
echo $glibc > $out/orig-glibc
