
# Testing `julia.withPackages`

This folder contains a test suite for ensuring that the top N most popular Julia packages (as measured by download count) work properly. The key parts are

* `top-julia-packages.nix`: an impure derivation for fetching Julia download data and processing it into a file called `top-julia-packages.yaml`. This YAML file contains an array of objects with fields "name", "uuid", and "count", and is sorted in decreasing order of count.
* `julia-top-n`: a small Haskell program which reads `top-julia-packages.yaml` and builds a `julia.withPackages` environment for each package, with a nice interactive display and configurable parallelism. It also tests whether evaluating `using <package-name>` works in the resulting environment.

> **Warning:**
> These tests should only be run on maintainer machines, not Hydra! `julia.withPackages` uses IFD, which is not allowed in Hydra.

## Quick start

``` shell
# Test the top 100 Julia packages
./run_tests.sh -n 100
```

## Options

You can run `./run_tests.sh --help` to see additional options for the test harness. The main ones are

* `-n`/`--top-n`: how many of the top packages to build (default: 100).
* `-p`/`--parallelism`: how many builds to run at once (default: 10).
* `-c`/`--count-file`: path to `top-julia-packages.yaml`.
