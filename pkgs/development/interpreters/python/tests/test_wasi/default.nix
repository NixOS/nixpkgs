# Cross-compile the interpreter and a pure Python package for WASI, and run them with wasmtime.
# The wrapper scripts of the Python package set cannot run on WASI. Thus the test sets `PYTHONPATH`.
{
  pkgsCross,
  runCommand,
  wasmtime,
  pythonAttr,
}:

let
  python = pkgsCross.wasi32.${pythonAttr};
  inherit (python.pkgs) tabulate;
in
runCommand "${python.name}-wasi-tabulate" { nativeBuildInputs = [ wasmtime ]; } ''
  export HOME=$TMPDIR
  wasmtime run --dir /nix/store \
    --env PYTHONPATH=${tabulate}/${python.sitePackages} \
    ${python.interpreter} -c 'from tabulate import tabulate; print(tabulate([["wasi", 1]]))' \
    | tee $out
  grep -q '^wasi  1$' $out
''
