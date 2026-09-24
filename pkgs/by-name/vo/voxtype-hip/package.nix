{
  voxtype,
  ...
}@args:

voxtype.override ({ hipSupport = true; } // removeAttrs args [ "voxtype" ])
