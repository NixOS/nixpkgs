# packages

Packages which are not created by the manifest builder.

## backendStdenv

We have our own `stdenv` for two reasons:

1. To ensure we use a compatible version of `gcc` with `nvcc`, and
2. To use `mold` as our default linker.

Elaborating on the second point: a non-trivial amount of time is spent *linking* when compiling CUDA code. The `mold` linker is much, *much* faster than the linkers GCC or LLVM use by default. As an example, on my machine with an i9-13900K and 96 GB of DDR5-6800 RAM, building CUTLASS 3.5.0 targeting `sm_75`:



```console
$ nix build -L --impure --builders '' .#cudaPackages.cutlass.showLinkTimesWithDefaultLinker \
  |& tee /dev/stderr \
  | awk '{ if ($2 " " $3 " " $4 == "Elapsed time (seconds):") sum += $5; } END { print sum; }'
...
8.39248
```

```console
$ nix build -L --impure --builders '' .#cudaPackages.cutlass.showLinkTimesWithMoldLinker \
  |& tee /dev/stderr \
  | awk '{ if ($2 " " $3 " " $4 == "Elapsed time (seconds):") sum += $5; } END { print sum; }'
...
5.93172
```

TODO: Next build uses unity.