{
  voxtype,
  ...
}@args:

voxtype.override (
  {
    onnxSupport = true;
    osdGtk4Support = true;
  }
  // removeAttrs args [ "voxtype" ]
)
