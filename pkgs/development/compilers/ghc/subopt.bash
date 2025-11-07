#!@shell@

# This script wraps the LLVM `opt(1)` executable and maps the options
# passed by old versions of GHC to the equivalents passed by newer
# versions that support recent versions of LLVM.
#
# It achieves the same effect as the following GHC change externally:
# <https://gitlab.haskell.org/ghc/ghc/-/merge_requests/8999>.
#
# This is used solely for bootstrapping newer GHCs from the GHC 9.0.2
# binary on AArch64, as that is the only architecture supported by that
# binary distribution that requires LLVM, and our later binary packages
# all use the native code generator for all supported platforms.
#
# No attempt is made to support custom LLVM optimization flags, or the
# undocumented flag to disable TBAA, or avoid
# <https://gitlab.haskell.org/ghc/ghc/-/issues/23870>, as these are not
# required to bootstrap GHC and at worst will produce an error message.
#
# It is called `subopt` to reflect the fact that it uses `opt(1)` as a
# subprocess, and the fact that the GHC build system situation
# requiring this hack is suboptimal.

set -e

expect() {
  if [[ $1 != $2 ]]; then
    printf >&2 'subopt: got %q; expected %q\n' "$1" "$2"
    return 2
  fi
}

if [[ $NIX_DEBUG -ge 1 ]]; then
  printf >&2 'subopt: before:'
  printf >&2 ' %q' "$@"
  printf >&2 '\n'
fi

args=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -enable-new-pm=0)
      shift 1
      ;;
    -mem2reg)
      expect "$2" -globalopt
      expect "$3" -lower-expect
      expect "$4" -enable-tbaa
      expect "$5" -tbaa
      args+=('-passes=function(require<tbaa>),function(mem2reg),globalopt,function(lower-expect)')
      shift 5
      ;;
    -O1)
      expect "$2" -globalopt
      expect "$3" -enable-tbaa
      expect "$4" -tbaa
      args+=('-passes=default<O1>')
      shift 4
      ;;
    -O2)
      expect "$2" -enable-tbaa
      expect "$3" -tbaa
      args+=('-passes=default<O2>')
      shift 3
      ;;
    *)
      args+=("$1")
      shift 1
      ;;
  esac
done

if [[ $NIX_DEBUG -ge 1 ]]; then
  printf >&2 'subopt: after:'
  printf >&2 ' %q' "${args[@]}"
  printf >&2 '\n'
fi

exec @opt@ "${args[@]}"
