{
  runCommand,
  flang,
}:
let
  flangExe = "${flang}/bin/flang";
  writeHello = ''
    cat > hello.f90 <<'EOF'
    program hello
    end program hello
    EOF
  '';
in
{
  compile-smoke = runCommand "flang-compile-smoke" { } ''
    set -euo pipefail

    ${writeHello}

    ${flangExe} -c hello.f90 -o compile.o
    [ -f compile.o ]

    cat > args.rsp <<'EOF'
    -c
    hello.f90
    -o
    response.o
    EOF

    ${flangExe} @args.rsp
    [ -f response.o ]

    touch $out
  '';

  driver-flags = runCommand "flang-driver-flags" { } ''
    set -euo pipefail

    ${writeHello}

    ${flangExe} -### -c hello.f90 > no-seed.log 2>&1
    if grep -F -- "-frandom-seed=" no-seed.log; then
      echo "wrapper unexpectedly injected -frandom-seed" >&2
      exit 1
    fi

    # Confirm that user-supplied NIX_CFLAGS_COMPILE does not leak into the
    # Fortran wrapper invocation: the wrapper must source flags from
    # NIX_FFLAGS_COMPILE only, so a marker placed in NIX_CFLAGS_COMPILE
    # must not appear in the resulting flang command line.
    NIX_CFLAGS_COMPILE="-Icflags-leak-marker-include" \
      ${flangExe} -### -c hello.f90 > cflags-isolation.log 2>&1
    if grep -F -- "cflags-leak-marker-include" cflags-isolation.log; then
      echo "NIX_CFLAGS_COMPILE leaked into the flang wrapper" >&2
      exit 1
    fi

    # Confirm that NIX_FFLAGS_COMPILE is the user-facing channel for
    # Fortran flags and flows through to the driver.
    NIX_FFLAGS_COMPILE="-Iffflags-marker-include" \
      ${flangExe} -### -c hello.f90 > fflags-passthrough.log 2>&1
    grep -F -- "ffflags-marker-include" fflags-passthrough.log

    ${flangExe} -### -fbuiltin -fno-builtin hello.f90 > builtin.log 2>&1
    grep -F -- "warning: '-fbuiltin' is not valid for Fortran" builtin.log
    grep -F -- "warning: '-fno-builtin' is not valid for Fortran" builtin.log
    if grep -F -- "error: unknown argument" builtin.log; then
      echo "builtin compatibility flags unexpectedly failed" >&2
      exit 1
    fi

    ${flangExe} -### -fexpensive-optimizations hello.f90 > ignored-flag.log 2>&1
    grep -F -- "optimization flag '-fexpensive-optimizations' is not supported" ignored-flag.log
    if grep -F -- "error: unknown argument" ignored-flag.log; then
      echo "ignored gfortran-style flag unexpectedly failed" >&2
      exit 1
    fi

    if ${flangExe} -### -complex-range=full hello.f90 > suggestion.log 2>&1; then
      echo "expected -complex-range=full to fail at the driver layer" >&2
      exit 1
    fi
    grep -F -- "error: unknown argument '-complex-range=full'" suggestion.log
    grep -F -- "did you mean '-Xflang -complex-range=full'" suggestion.log
    if grep -F -- "-Xclang -complex-range=full" suggestion.log; then
      echo "driver suggested -Xclang instead of -Xflang" >&2
      exit 1
    fi

    touch $out
  '';
}
