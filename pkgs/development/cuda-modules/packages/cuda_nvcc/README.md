# cuda_nvcc

## nvcc wrapper

`bin/nvcc` is a wrapper around the nvcc of NVIDIA, which is installed as `bin/.nvcc-wrapped`. The wrapper is built from
[`nvcc-wrapper.cpp`](./wrappers/nvcc-wrapper.cpp) by [`nvcc-wrapper.nix`](./nvcc-wrapper.nix) (`passthru.nvccWrapper`) with the
ordinary stdenv, and copied into `cuda_nvcc`. It does two things:

- It puts the host compiler that nvcc requires (`backendStdenv.cc`) on `PATH`.
- It passes nvcc the options that make its output reproducible, so that a rebuild writes the same objects and
  programs.

Two facts are compiled into the wrapper: the directory of the host compiler, and whether nvcc has `--frandom-seed`.
The wrapper is therefore built once for each combination of the two, not once for all CUDA releases.

### Why

Without these options, nvcc writes a different object each time it compiles the same source file. There are two
causes.

The first cause is the names of the intermediate files. nvcc names them after its process ID, for example
`tmpxft_<pid>_<n>-<m>_<source>.cudafe1.cpp`, and the host compiler compiles the host code from them. The host compiler
stores the file name in the symbol table of the object, as the `STT_FILE` symbol. It also names the function that runs
the static initializers after the file: `_GLOBAL__sub_I_tmpxft_<pid>_...`. `strip -S` removes the `STT_FILE` symbol,
but it does not remove the name of that function.

The second cause is the names of entities with internal linkage, for example functions in an unnamed namespace. nvcc
gives every source file an identifier and puts it into these names: `_INTERNAL_<identifier>...` and
`_GLOBAL__N__<identifier>`. The names are used in the host code and in the device code. The identifier is the same in
every build if the source file defines a function or a variable that has external linkage and is not a template. If
the source file defines no such function or variable, the identifier contains the process ID. Source files that define
only templates are an example, and some of the CUDA modules of OpenCV contain such files.

nvcc has one option for each cause:

- `--keep` tells nvcc not to remove its intermediate files. nvcc then names them after the source file:
  `<source>.cudafe1.cpp`.
- `--frandom-seed` tells nvcc to derive the identifier from a seed. nvcc has this option from CUDA 12.9. nvcc also
  passes the seed to the host compiler as `-frandom-seed`. NVIDIA requires a different seed for every source file of a
  program.

These options cannot be set once for a whole build, for example through `NVCC_PREPEND_FLAGS` in `setupCudaHook`:

- `--keep` needs a directory for the intermediate files (`--keep-dir`). With one directory for the whole build, two
  source files that have the same name and are compiled at the same time would overwrite each other's files.
- The seed would be the same for every source file.

`--objdir-as-tempdir` looks like an alternative to `--keep`, because it names the intermediate files after the object
and needs no directory. It has two problems:

- It has no effect without `-c`. The object is then an intermediate file itself, and nvcc names it after the process
  ID.
- nvcc fails if the directory of the object is not writable, for example with `-o /dev/null`.

### How

The wrapper runs `.nvcc-wrapped` from its own directory. It finds that directory through `/proc/self/exe`, so this
also works when the wrapper is run through a symbolic link, for example from `cudatoolkit`. nvcc gets the same
`argv[0]` and the same environment, except for `PATH`.

The wrapper adds options only if nvcc is given at least one source file. It reads the arguments and the options files
(`-optf`) that they name, and it looks for two things: the names of the source files, and the options listed below.
It computes a hash of the working directory and of the arguments, called `<id>` below. `<id>` is the same when the
same command runs again in the same directory, as in a rebuild. It is different for every source file of a build.

The wrapper passes these options:

- `--frandom-seed=<id>`, from CUDA 12.9.
- `--keep --keep-dir=$TMPDIR/nvcc-keep-<id>`. The wrapper creates this directory and removes it when nvcc exits. The
  name of the directory must not be random, because the path of the intermediate files is part of the debugging
  information of the host code (`-g`).

The wrapper does not override the caller. The caller can set options on the command line, in an options file, in
`NVCC_PREPEND_FLAGS` or in `NVCC_APPEND_FLAGS`.

- If the caller passes a seed, the wrapper does not pass one.
- If the caller passes `--keep`, `--keep-dir`, `--save-temps` or `--objdir-as-tempdir`, the wrapper passes neither
  `--keep` nor `--keep-dir`. CMake depends on this: it identifies nvcc from the intermediate files that it tells nvcc
  to keep.
- If two of the source files have the same name, the wrapper passes neither `--keep` nor `--keep-dir`. Without `-c`,
  nvcc keeps the objects in the same directory as the other intermediate files, so the second object would overwrite
  the first.

The wrapper puts its options before the options of the caller. nvcc uses the last value of an option, so an option of
the caller that the wrapper missed still takes precedence.

The wrapper never fails a build that nvcc would complete. If it cannot read an options file, it adds no options, and
nvcc reports the error. If an options file is not a regular file (e.g. a pipe), the wrapper does not read it and adds
no options, because nvcc would otherwise find it empty. If it cannot create the directory, or the directory exists and belongs to another user, it
passes neither `--keep` nor `--keep-dir`.

If the wrapper created a directory, it waits for nvcc and then removes the directory. While it waits, it treats nvcc
as the nvlink wrapper treats nvlink, with the same code ([`wrapper.hpp`](./wrappers/wrapper.hpp)): it forwards signals, nvcc is
killed if the wrapper dies, and the wrapper exits with the status of nvcc or is killed by the same signal. The section
on the nvlink wrapper describes this. If the wrapper is killed with `SIGKILL`, the directory stays behind. The next
run of the same command uses it and removes it. Without a directory, the wrapper replaces itself with nvcc.

Two things are not fixed:

- Before CUDA 12.9 there is no `--frandom-seed`. A source file that defines only templates and entities with internal
  linkage still gets the process ID in its symbol names.
- Objects still depend on the directory in which they are built. The identifier contains a hash of the path of the
  source file, and debugging information contains the working directory.

### Testing

- `cudaPackages.cuda_nvcc.tests.nvcc-reproducible` compiles sources twice and compares the results. It also checks
  that `bin/.nvcc-wrapped` without the wrapper still writes different objects. That check fails when a CUDA release no
  longer needs the options.
- `cudaPackages.cuda_nvcc.tests.nvcc-options` checks with nvcc that the options of the caller have their effect.
- `cudaPackages.cuda_nvcc.tests.nvcc-wrapper` puts the installed wrapper next to a stand-in for nvcc
  ([`tests/fake-tool`](./tests/fake-tool)). It checks which options the wrapper adds, and how the wrapper runs nvcc
  and removes the directory.

To check a package, build it twice and compare the outputs, for example with `nix-build --check`. A small test source
can be reproducible where a package is not, so check the package itself.

## nvlink wrapper

`bin/nvlink` is a wrapper around NVIDIA's nvlink, which is installed as `bin/.nvlink-wrapped`. The wrapper is built
from [`nvlink-wrapper.cpp`](./wrappers/nvlink-wrapper.cpp) by [`nvlink-wrapper.nix`](./nvlink-wrapper.nix)
(`passthru.nvlinkWrapper`) with the ordinary stdenv, once for every CUDA release, and copied into `cuda_nvcc`.

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

The wrapper runs `.nvlink-wrapped` from its own directory (found through `/proc/self/exe`, so also when the wrapper
is run through a symbolic link, e.g. from `cudatoolkit`) with the same arguments (including `argv[0]`, whose basename
nvlink records as the tool name) and environment. If nvlink succeeds, the wrapper overwrites with `e`s, as
`remove-references-to` does, each hash of a path in the Nix store (32 characters of Nix's base-32 alphabet, which lacks
`e`) in the `.note.nv.tkinfo` sections of its output. Nix finds references by these hashes, whatever the spelling of
the path. The wrapper reads only the ELF headers it needs and those sections, and writes back only the sections which
change, so the output's size and layout are unchanged: only the recorded command lines change, e.g. to
`-L /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-cuda_nvcc-13.4.92/...`.

The only arguments the wrapper interprets are those naming the output (the last `-o` or `--output-file`), including
those in options files (`-optf`), which nvcc uses for long command lines. It depends on nothing else of nvlink: not on
the format of the note, nor on which arguments nvlink records.

The wrapper forwards `SIGHUP`, `SIGINT`, `SIGQUIT`, `SIGTERM`, `SIGUSR1`, and `SIGUSR2` to nvlink, so that nvlink
receives each signal sent to the wrapper once:

- In the foreground of a terminal, nvlink stays in the wrapper's process group, so signals from the terminal (e.g.
  Ctrl-C) reach it directly, and the wrapper doesn't forward them.
- Otherwise, as in a build, nvlink runs in a process group of its own, so a signal sent to the wrapper's process group
  (e.g. by `timeout`) reaches nvlink only by being forwarded.

nvlink is killed if the wrapper dies. If nvlink fails, the wrapper exits with its status, or is killed by the same
signal, and leaves the output as nvlink left it.

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
directly, e.g. Clang, whose `clang-nvlink-wrapper` runs nvlink from the CUDA installation for relocatable device code
(`-fgpu-rdc`) and passes Clang's own library directory, which nvlink records too. It doesn't remove references to the
Nix store from anything else, e.g. the line information of device code compiled with `-lineinfo` or `-G`.

The libraries which produce device code record only options in the note, never search paths or other paths in the Nix
store (checked with CUDA 13.4): nvJitLink, nvPTXCompiler, NVRTC, and ptxas (which records at most the basenames of
files). nvJitLink, like CUDA 13's nvlink, keeps the notes of the cubins it links, so a cubin written by an unwrapped
nvlink passes its paths on. No package in Nixpkgs uses these libraries to produce device code while building.

### Testing

- `cudaPackages.cuda_nvcc.tests` links with nvcc and nvlink in the ways listed above, and with Clang (CUDA 12.8 and
  12.9, as Clang 21 can't parse CUDA 13's headers, and not on x86_64, where the Clang wrapper passes the device code a
  flag Clang rejects), and checks the notes in the results with `cuobjdump`; the results must not refer to `cuda_nvcc`
  or `cuda_cudart` (or Clang). `cuobjdump` also reads the notes of compressed fatbins (`-Xfatbin -compress-all`), in
  which Nix doesn't find references, so `nvcc-compressed` checks those. The `wrapper` test puts the installed wrapper
  next to a stand-in for nvlink ([`tests/fake-tool`](./tests/fake-tool)) to check how it runs nvlink and handles
  its output. With CUDA 12.6, nvlink writes no note, so only the `wrapper` test checks the wrapper.
- `cudaPackages.cuda_nvcc.gpuCheck` (requires a GPU) runs programs linked through the wrapper.

When the wrapper fails, run the command with `bin/.nvlink-wrapped` in place of `bin/nvlink` and inspect its output with
`cuobjdump -elf`.

### Development

Both wrappers are C++23 and build with stdenv's compiler. They share [`wrapper.hpp`](./wrappers/wrapper.hpp): how they read
options files, find the tool they wrap, and run it. Defining `NVLINK_WRAPPER_NO_MAIN` omits `main` from the nvlink
wrapper, so `tokenize`, `findOutput`, and `scrub` (on a `std::span<char>` holding an output) can be exercised directly,
e.g. by a fuzzer including the source file. Before changing a wrapper, check it with `clang-tidy`, `cppcheck`,
`g++ -fanalyzer`, and a build with `-fsanitize=address,undefined` running the tests above.
