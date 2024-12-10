{ interpreter, gdb, writeText, runCommand }:

let
  crashme-py = writeText "crashme.py" ''
    import ctypes

    def sentinel_foo_bar():
        ctypes.memset(0, 1, 1)

    sentinel_foo_bar()
  '';
in runCommand "python-gdb" {} ''
  # test that gdb is able to recover the python stack frame of this segfault
  ${gdb}/bin/gdb -batch -ex 'set debug-file-directory ${interpreter.debug}/lib/debug' \
    -ex 'source ${interpreter}/share/gdb/libpython.py' \
    -ex r \
    -ex py-bt \
    --args ${interpreter}/bin/python ${crashme-py} | grep 'in sentinel_foo_bar' > /dev/null

  # success.
  touch $out
''
