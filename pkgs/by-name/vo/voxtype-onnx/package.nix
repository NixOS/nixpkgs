{
  voxtype,
  ...
}@args:

voxtype.override ({ onnxSupport = true; } // removeAttrs args [ "voxtype" ])
