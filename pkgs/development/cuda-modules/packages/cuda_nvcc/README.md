# cuda_nvcc

## nvlink wrapper

`bin/nvlink` is a wrapper, built from [`nvlink-wrapper.cpp`](./nvlink-wrapper.cpp), around NVIDIA's nvlink, which is
installed as `bin/.nvlink-wrapped`.

### Why

nvlink records its command line in a note (`.note.nv.tkinfo`) in each cubin it writes, which nvcc embeds in the
`.nv_fatbin` section of the binary or object it links. The command line includes the library search paths (`-L`),
both those from `nvcc.profile` and those passed by the build, and with link-time optimization the NVVM directory
(`-nvvmpath`). Without the wrapper, these paths in the Nix store make `cuda_nvcc` and the build's dependencies runtime
dependencies of everything linked with nvcc, whether through a whole-program link, a link of relocatable device code,
or a device-link object (`nvcc -dlink`) in a static library, and whether the result is linked statically or
dynamically. (Nix doesn't find references in fatbins compressed with `-Xfatbin -compress-all`, but the paths are still
there.)

`cuobjdump -elf` shows the note (abridged):

```
.section .note.nv.tkinfo
    Tool Name: nvlink
    Tool Version: Cuda compilation tools, release 13.4, V13.4.92
    Tool Command Line Arguments: -arch sm_121a -m 64 -l cudadevrt -L /nix/store/...-cuda_cudart-13.4.92/lib,/nix/store/...-cuda_nvcc-13.4.92/bin/..//lib/stubs,... -cpu-arch AARCH64
```

nvlink writes the note from CUDA 12.8 for some architectures (e.g. `sm_100`, `sm_120`, and `sm_121a`, but not `sm_89`
or `sm_90`), and from CUDA 13 for all of them. CUDA 13's nvlink also keeps the notes of the cubins (`*.cubin`) it
links; CUDA 12's drops them. Neither nvlink nor nvcc has an option to omit the note or the arguments it records.

The alternatives don't work:

- Setting `LIBRARY_PATH` in `nvcc.profile` keeps nvcc's own directories out of the note, as nvlink searches it without
  recording it, but not the `-L` passed by builds; and link-time optimization requires `-nvvmpath`.
- Removing references after the build (e.g. with `remove-references-to`) has to be done by every package, and removes
  legitimate references to the same store paths.
- `patchelf` and `objcopy` work with whole sections; the note is inside `.nv_fatbin`, a container which
  only nvcc's tools write.
- `makeBinaryWrapper` can neither rewrite arguments nor run anything after the program it wraps.

### How

The wrapper runs nvlink with the same arguments (including `argv[0]`, whose basename nvlink records as the tool name)
and environment. If nvlink succeeds, the wrapper overwrites with spaces each hash of a path in the Nix store (32
characters of Nix's base-32 alphabet) in the `.note.nv.tkinfo` sections of its output. Nix finds references by these
hashes, whatever the spelling of the path, and overwriting them in place leaves the output's size and layout unchanged:
only the recorded command lines change, e.g. to `-L /nix/store/                                -cuda_nvcc-13.4.92/...`.

The only arguments the wrapper interprets are those naming the output (the last `-o` or `--output-file`), including
those in options files (`-optf`), which nvcc uses for long command lines. It depends on nothing else of nvlink: not on
the format of the note, nor on which arguments nvlink records.

The wrapper forwards `SIGHUP`, `SIGINT`, `SIGQUIT`, `SIGTERM`, `SIGUSR1`, and `SIGUSR2` to nvlink, except those from the
terminal, which reach nvlink directly. nvlink is killed if the wrapper dies. If nvlink fails, the wrapper exits with its
status, or is killed by the same signal, and leaves the output as nvlink left it.

Rather than let a reference through, the wrapper fails with an error starting with `nvlink wrapper: error:`, removing
the output if nvlink wrote it, when:

- it can't parse the arguments naming the output (e.g. an options file which isn't a regular file, which nvlink would
  then find empty, as the wrapper reads options files first), before nvlink runs;
- the output exists and isn't a regular file (e.g. `/dev/stdout` when it's a pipe), which the wrapper couldn't read
  back, before nvlink runs;
- nvlink didn't write the output the wrapper found, e.g. because they disagree on the arguments;
- the output is an ELF file which isn't 64-bit and little-endian (as every CUDA ELF file is), or is malformed; or
- the output isn't an ELF file (e.g. a host linker script, from `-ghls`), but refers to the Nix store.

The wrapper is found wherever nvcc runs (nvcc looks for nvlink next to itself), as well as by anything running nvlink
directly. It doesn't remove references to the Nix store from anything else, e.g. the line information of device code
compiled with `-lineinfo` or `-G`.

### Testing

- `cudaPackages.cuda_nvcc.tests` links with nvcc and nvlink in the ways listed above and checks the notes in the
  results with `cuobjdump`; the results must not refer to `cuda_nvcc` or `cuda_cudart`. Its `wrapper` test builds the
  wrapper around a stand-in for nvlink ([`tests/fake-nvlink`](./tests/fake-nvlink)) to check how it runs nvlink and
  handles its output. With CUDA 12.6, nvlink writes no note, so only the `wrapper` test checks the wrapper.
- `cudaPackages.cuda_nvcc.gpuCheck` (requires a GPU) runs programs linked through the wrapper.

When the wrapper fails, run the command with `bin/.nvlink-wrapped` in place of `bin/nvlink` and inspect its output with
`cuobjdump -elf`.

### Development

The wrapper is C++23 and builds with each CUDA package set's host compiler (GCC 13 and newer). Defining
`NVLINK_WRAPPER_NO_MAIN` omits `main`, so `tokenize`, `findOutput`, and `scrub` can be exercised directly, e.g. by a
fuzzer including the source file. Before changing it, check it with `clang-tidy`, `cppcheck`, `g++ -fanalyzer`, and a
build with `-fsanitize=address,undefined` running the tests above.
