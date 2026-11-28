#!@shell@
# Apple targets use the unwrapped clang, everything else the wrapped one.
prev=
for arg in "$@"; do
  case "$prev/$arg" in
    -target/*-apple-* | -triple/*-apple-* | */--target=*-apple-*)
      exec "@apple@" "$@"
      ;;
  esac
  prev=$arg
done
exec "@host@" "$@"
