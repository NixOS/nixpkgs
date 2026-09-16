The initialization regression compiles the pinned `SFrameParser.cpp`,
`ResourceTrackerTest.cpp`, `FunctionExtrasTest.cpp`, and `IteratorTest.cpp` against
the repaired headers. It also runs a small executable covering iterator copies
before dereference, default/explicit test-helper values, and empty/nonempty
SFrame ranges in both endiannesses.

Use an already installed LLVM from the same revision for generated headers and
`libLLVMSupport`, with a compiler that produces executables for this machine:

```sh
python3 initialization.py \
  --source-root /path/to/llvm-source \
  --installed-llvm /path/to/matching-installed-llvm \
  --cxx /path/to/c++ --output /tmp/llvm-initialization
```

Add `--unpatched` and use another output directory for a baseline control. The
script records exact commands and source/patch hashes. The known uninitialized
copies need not change the program's visible result, so compare diagnostics as
well as runtime status. This compiles selected unit-test translation units; it
does not execute the full LLVM test suite or sanitize the installed library.
