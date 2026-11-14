{
  voxtype,
  ...
}@args:

voxtype.override (
  {
    vulkanSupport = true;
    osdGtk4Support = true;
  }
  // removeAttrs args [ "voxtype" ]
)
