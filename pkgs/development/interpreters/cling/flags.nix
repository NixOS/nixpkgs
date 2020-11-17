{cling, gcc-unwrapped, glibc}:

# This file contains a list of flags used to "isolate" a Cling installation.
# This means
# a) prevent it from searching for system include files and libs
# b) provide it with the include files and libs it needs (C and C++ standard library)

# This is provided as a separate file because it's handy to be able to be able to pass them
# to tools that wrap Cling, particularly Jupyter kernels such as xeus-cling and the built-in
# jupyter-cling-kernel.

# Both of these use Cling as a library by linking against libclingJupyter.so, so the
# makeWrapper approach to wrapping the binary doesn't work.
# Thus, if you're packaging a Jupyter kernel, you either need to pass these flags as extra
# args to xcpp (for xeus-cling) or put them in the environment variable CLING_OPTS
# (for jupyter-cling-kernel)

[
  "-nostdinc"
  "-nostdinc++"
  "-I" "${gcc-unwrapped}/include/c++/9.3.0"
  "-I" "${cling}/include"
  "-I" "${glibc.dev}/include"
  "-I" "${gcc-unwrapped}/include/c++/9.3.0/x86_64-unknown-linux-gnu"
  "-I" "${cling}/lib/clang/5.0.2/include"
  "-L" "${cling}/lib"
]
