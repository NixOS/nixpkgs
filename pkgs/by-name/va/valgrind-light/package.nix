{
  valgrind,
}:

(valgrind.override { gdb = null; }).overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    description = "${oldAttrs.meta.description} (without GDB)";
  };
})
