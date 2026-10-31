{
  voxtype,
  ...
}@args:

voxtype.override (
  {
    onnxSupport = true;
    osdGtk4Support = true;
    osdNativeSupport = true;
  }
  // removeAttrs args [ "voxtype" ]
)
