{
  vcpkg-tool,
  ...
}@args:

vcpkg-tool.override (
  {
    doWrap = false;
  }
  // removeAttrs args [ "vcpkg-tool" ]
)
