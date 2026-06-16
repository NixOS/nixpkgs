{
  testdisk,
  ...
}@args:

testdisk.override (
  {
    enableQt = true;
  }
  // removeAttrs args [ "testdisk" ]
)
