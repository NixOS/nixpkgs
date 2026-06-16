{
  teeworlds,
  ...
}@args:

teeworlds.override (
  {
    buildClient = false;
  }
  // removeAttrs args [ "teeworlds" ]
)
