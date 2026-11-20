{
  voxtype,
  ...
}@args:

voxtype.override ({ vulkanSupport = true; } // removeAttrs args [ "voxtype" ])
