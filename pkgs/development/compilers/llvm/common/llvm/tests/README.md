This shared regression covers the initialization patches used by LLVM and Triton
LLVM. It compiles the pinned ResourceTracker, FunctionExtras and Iterator unit
test translation units, plus SFrameParser.cpp on versions containing SFrame.
A small executable checks a pointer iterator wrapping a std::function-backed
filtered iterator, copies and moves before dereference, default/explicit test
helper values, and empty/nonempty SFrame ranges in both endiannesses.
Compile-time traits ensure that the filtered iterator is nontrivially copied and
moved. The plain-pointer iterator remains a separate behavior control; its
trivial-copy case alone is not evidence of an invalid scalar evaluation.

Use an unpatched llvm-project source tree and matching installed LLVM for
generated headers and libLLVMSupport. llvm-config supplies the include and library
locations, including split Nix outputs. The compiler, llvm-config, and compiled
executables must run on the test machine:

```sh
python3 initialization.py \
  --source-root /path/to/llvm-source \
  --llvm-config /path/to/matching-installed-llvm/bin/llvm-config \
  --cxx /path/to/c++ --output /tmp/llvm-initialization
```

LLVM18 has no CountCopyAndMove header; LLVM18–21 have no SFrame implementation.
The script records these absent features rather than inventing replacement tests.
Add `--unpatched` with another output directory for a baseline control. Exact
commands and source, patch, fixture and runner hashes are recorded. Indeterminate
copies need not produce a visible numerical failure; compare diagnostics as well
as runtime status. Passing this focused test does not prove the absence of every
uninitialized read, execute the full LLVM suite, or sanitize the installed library.
